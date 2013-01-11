#-*- encoding: utf-8 -*-
class EBooksController < ApplicationController
  LIMIT_PER_PAGE = 10 

  if Rails.env == :production then
    before_filter :require_login, :only=>[:new, :edit]
  end

  def root
    redirect_to url_for(:controller=>:e_books, :action=>:index)
  end

  # GET /e_books
  def index
    page
  end

  # GET /e_books/page/1
  def page
    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end
    offset = (@page_id - 1) * LIMIT_PER_PAGE

    @title = "第#{@page_id}页"
    @e_books = EBook.order('created_at desc').limit(LIMIT_PER_PAGE).offset(offset)
    @page_count = (EBook.count / LIMIT_PER_PAGE.to_f).ceil

    render 'index.html.erb'
  end

  # GET /e_books/1
  def show
    @e_book = EBook.find(params[:id])
    @related_ebooks = @e_book.related_ebooks
    @title = view_context.standard_file_name @e_book
		@description = "出版社: #{@e_book.e_book_attrs.where('attr_id = ?', Attr.where(:name=>:publisher).first.id).first.value}; 格式: #{@e_book.format}; 语言: #{@e_book.language}; 作者: #{@e_book.author}; 出版年份: #{@e_book.publish_year}"
    respond_to do |format|
      format.html
    end
  end

  # GET /e_books/new
  def new
    @title = "创建电子书"
    @e_book = EBook.new
		@e_book.publish_year = Date.today.year
  end

  # GET /e_books/1/edit
  def edit
    @title = "编辑电子书"
    @e_book = EBook.find(params[:id])
  end

  # POST /e_books
  def create
    puts params
    @e_book = EBook.new(params[:e_book])

    begin
      ActiveRecord::Base.transaction do
        unless @e_book.save then raise '新增失败！' end
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
      redirect_to url_for(:controller=>:e_books, :action=>:new), notice: ex.message
    end
  end

  # DELETE /e_books/1
  def destroy
=begin
    @e_book = EBook.find(params[:id])
    @e_book.destroy

    respond_to do |format|
      format.html { redirect_to e_books_url }
    end
=end
  end

	def export
		result = { :e_books => EBook.export, :webstorage_links => WebstorageLink.export }

		respond_to do |format|
			format.json { render json: result }
			format.html
		end
	end

	def import
    if params['import_file'] then
      docs = JSON.load params['import_file'].read
      EBook.import docs['e_books']
      WebstorageLink.import docs['webstorage_links ']
    elsif params['import_url'] then
      require 'net/http'
      docs = JSON.load Net::HTTP.get(URI(params['import_url']))
      EBook.import docs['e_books'], params['import_url']
      WebstorageLink.import docs['webstorage_links']
    end
	end

  def rss
    _sitemap_rss
    _top10new_rss
  end

  private
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

    File.open("#{ENV['OPENSHIFT_REPO_DIR']}/public/data_feeds/sitemap.rss.xml", 'wb') do |f|
      f.write the_rss
    end
  end

  def _top10new_rss
    require 'rss'
    the_rss = RSS::Maker::RSS20.make do |maker|
      maker.channel.title = '电子书(EBook)下载'
      maker.channel.description = '最新发布的10本书籍'
      maker.channel.link = 'http://ebook.jiani.info'

      EBook.order('created_at desc').limit(LIMIT_PER_PAGE).all.each do |ebook|
        maker.items.new_item do |item|
          item.link = url_for(ebook) 
          item.title = ebook.name
          item.description = "<p><strong>作者:</strong> #{ebook.author}</p><p><strong>下载地址:</strong></p> <a href='#{url_for(ebook)}'>#{url_for(ebook)}</a>"
          item.pubDate = ebook.updated_at.to_s
        end
      end
    end

    File.open("#{ENV['OPENSHIFT_REPO_DIR']}/public/data_feeds/ebooks.rss.xml", 'wb') do |f|
      f.write the_rss
    end
  end
end
