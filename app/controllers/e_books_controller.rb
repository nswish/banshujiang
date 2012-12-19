#-*- encoding: utf-8 -*-
class EBooksController < ApplicationController
  LIMIT_PER_PAGE = 10 

  def root
    redirect_to url_for(:controller=>:e_books, :action=>:index)
  end

  # GET /e_books
  def index
    puts params[:programming_languages]
    page
  end

  # GET /e_books/page/1
  def page
    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end
    offset = (@page_id - 1) * LIMIT_PER_PAGE

    condition = {}
    if params[:programming_languages] then
      condition[:programming_language] = params[:programming_languages].keys
    end
    if params[:publishers] then
      condition[:publisher] = params[:publishers].keys
    end

    @e_books = EBook.where(condition).order('created_at desc').limit(LIMIT_PER_PAGE).offset(offset)

    @page_count = (EBook.where(condition).count / LIMIT_PER_PAGE.to_f).ceil

    render 'index.html.erb'
  end

  # GET /e_books/1
  def show
    @e_book = EBook.find(params[:id])
    @title = view_context.standard_file_name @e_book
  end

  # GET /e_books/new
  def new
    @title = "创建电子书"
    @e_book = EBook.new
  end

  # GET /e_books/1/edit
  def edit
    @title = "编辑电子书"
    @e_book = EBook.find(params[:id])
  end

  # POST /e_books
  def create
    @e_book = EBook.new(params[:e_book])
    cookies[:token] = params[:token]

    if params[:token]=='zwyxyz' and @e_book.save
      rss
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>@e_book.id), notice: '新增成功！'<<view_context.site_name<<view_context.standard_file_name(@e_book)
    else
      redirect_to url_for(:controller=>:e_books, :action=>:new), notice: '新增失败！'
    end
  end

  # PUT /e_books/1
  def update
    @e_book = EBook.find(params[:id])
    cookies[:token] = params[:token]

    if params[:token]=='zwyxyz' and @e_book.update_attributes(params[:e_book])
      redirect_to url_for(:controller=>:e_books, :action=>:edit), notice: '更新成功！'
      rss
    else
      redirect_to url_for(:controller=>:e_books, :action=>:edit), notice: '更新失败！'
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

  private
  def rss
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
        end
      end
    end

    File.open("#{ENV['OPENSHIFT_REPO_DIR']}/public/data_feeds/ebooks.rss.xml", 'wb') do |f|
      f.write the_rss
    end
  end
end
