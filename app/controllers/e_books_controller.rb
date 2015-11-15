#-*- encoding: utf-8 -*-
class EBooksController < ApplicationController
  LIMIT_PER_PAGE = 10  

  before_filter :require_login, :only=>[:new, :edit]

  def root
    redirect_to url_for(:controller=>:e_books, :action=>:index)
  end

  # GET /e_books
  def index
    @latest_10_books = EBook.order('id desc').limit(8).all
    @download_10_books = EBook.order('download_count desc').limit(8).all
  end

  def exists
    respond_to do |format|
      format.json { render :json => { 'exists' => EBook.where(:name => params[:name]).count > 0} }
    end
  end

  # GET /e_books/page/1
  def page
    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end
    offset = (@page_id - 1) * LIMIT_PER_PAGE

    @title = "第#{@page_id}页"
    @e_books = EBook.order('id desc').limit(LIMIT_PER_PAGE).offset(offset)
    @page_count = (EBook.count / LIMIT_PER_PAGE.to_f).ceil
  end

  # GET /e_books/1
  def show
    id = params[:id]

    respond_to do |format|
      format.html { 
        @e_book = EBook.find(id)
        @title = view_context.standard_file_name @e_book
      }
      format.json {
        render json: EBook.exists?(id) ? EBook.find(id).full_data : {}
      }
    end
  end

  # GET /e_books/new
  def new
    @title = "创建电子书"
    @e_book = EBook.new
    @e_book.publish_year = Date.today.year
    @e_book.list_id = List.order('id desc').first.id
  end

  # GET /e_books/1/edit
  def edit
    @title = "编辑电子书"
    @e_book = EBook.find(params[:id])
  end

  # POST /e_books
  def create
    @e_book = EBook.new(params[:e_book])
    @e_book.download_count = 0

    begin
      ActiveRecord::Base.transaction do
        unless @e_book.save then raise '新增失败！'+"#{@e_book.errors.full_messages}" end
        params[:e_book_attrs].each do |e_book_attr| 
          e_book_attr[:e_book_id] = @e_book.id
          @e_book.e_book_attrs.create(e_book_attr) unless (e_book_attr[:value].strip! || e_book_attr[:value]).blank?
        end
      end
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>@e_book.id), notice: '新增成功！'
    rescue Exception=>ex
      redirect_to url_for(:controller=>:e_books, :action=>:new), notice: ex.message
    end
  end

  # PUT /e_books/1
  def update
    @e_book = EBook.find(params[:id])

    begin
      ActiveRecord::Base.transaction do
        unless @e_book.update_attributes params[:e_book] then raise '更新失败！' end
        @e_book.e_book_attrs.clear

        params[:e_book_attrs].each do |e_book_attr| 
          @e_book.e_book_attrs.create(e_book_attr) unless (e_book_attr[:value].strip! || e_book_attr[:value]).blank?
        end
      end
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>@e_book.id), notice: '更新成功！'
    rescue Exception=>ex
      redirect_to url_for(:controller=>:e_books, :action=>:edit), notice: ex.message
    end
  end

  def need_sync
    ebook = EBook.find(params[:id])
    client = HTTPClient.new

    res = client.get "http://ebook.jiani.info/e_books/#{ebook.id}.json"

    remote_ebook_data = JSON.load res.body
    ebook_data = JSON.load ebook.full_data.to_json

    if remote_ebook_data['ebook'] then
      remote_ebook_data['ebook'].delete 'download_count'
      ebook_data['ebook'].delete 'download_count'

      render json: { status: !ebook_data.eql?(remote_ebook_data) }
    else
      render json: { status: true }
    end
  end

  def search
    content = params[:search_words].strip
    @e_books = EBook.search content

    search_word = SearchWord.where(:content=>content).first

    if search_word then
      search_word.search_count = search_word.search_count + 1
    else
      search_word = SearchWord.new(:content=>content, :search_count=>1)
    end

    search_word.save
  end

  def restthings
    cookies[:token] = "zwyxyz"

    EBook.refresh_cache
    _sitemap_rss

    render :inline=>"<a href='/'>all ok!</a>"
  end

  # 获取书籍的完整导出信息
  def upload
    id = params[:id]
    ebook = EBook.find(id)

    client = HTTPClient.new

    res = client.post 'http://ebook.jiani.info/e_books/receive', :body=>ebook.full_data.to_json, :header=>{'Content-Type'=>'application/json'}

    render :json=>{ :data => "#{res.body}" }
  end

  # 接收数据
  def receive
    in_ebook = params[:ebook]
    in_ebook_attrs = params[:ebook_attrs] || []
    in_ebook_webstorage_links = params[:ebook_webstorage_links] || []

    begin
      ActiveRecord::Base.transaction do
        
        # ebook
        _hashToModel(in_ebook, EBook)

        # ebook_attrs
        in_ebook_attrs.each do |in_ebook_attr|
          _hashToModel(in_ebook_attr, EBookAttr)
        end
        
        # ebook_webstorage_links
        in_ebook_webstorage_links.each do |in_ebook_webstorage_link|
          _hashToModel(in_ebook_webstorage_link, WebstorageLink)
        end
      end

      render :inline=>'ok'
    rescue Exception=>ex
      render :inline=>"fail: #{ex}"
    end
  end
    
  private
  def _hashToModel(hash, model)
    id = hash[:id]
      
    inst = model.exists?(id) ? model.find(id) : model.new

    hash.each do |attr|
      inst.send "#{attr[0]}=", attr[1]
    end

    unless inst.save then raise inst.errors.messages[:name] end
  end
  
  def _sitemap_rss
    require 'rss'
    the_rss = RSS::Maker::RSS20.make do |maker|
      maker.channel.title = "[#{view_context.site_name}] http://ebooks.jiani.info"
      maker.channel.description = '所有书籍'
      maker.channel.link = 'http://ebook.jiani.info'

      EBook.all.each do |ebook|
        maker.items.new_item do |item|
          item.link = url_for(ebook) 
          item.title = ebook.name
          item.description = "<p><strong>作者:</strong> #{ebook.author}</p><p><strong>下载地址:</strong></p> <a href='#{url_for(ebook)}'>#{url_for(ebook)}</a>"
          item.pubDate = ebook.updated_at.to_s
        end
      end
    end

    File.open(File.expand_path("../../../public/data_feeds/sitemap.rss.xml", __FILE__), 'wb') do |f|
      f.write the_rss
    end
  end
end
