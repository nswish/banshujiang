#-*- encoding: utf-8 -*-
class EBooksController < ApplicationController
  LIMIT_PER_PAGE = 7 

  # GET /e_books
  def index
    self.page
  end

  # GET /e_books/page/1
  def page
    @title = '电子书(EBook)下载'

    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end
    @page_count = (EBook.count / LIMIT_PER_PAGE.to_f).ceil

    offset = (@page_id - 1) * LIMIT_PER_PAGE
    @e_books = EBook.order('created_at desc').limit(LIMIT_PER_PAGE).offset(offset).all

    render 'index.html.erb'
  end

  # GET /e_books/1
  def show
    @e_book = EBook.find(params[:id])
    @title = "[#{@e_book.name}].#{@e_book.publish_year}.#{@e_book.language}版.#{@e_book.format}"
  end

  # GET /e_books/new
  def new
    @e_book = EBook.new
  end

  # GET /e_books/1/edit
  def edit
    @e_book = EBook.find(params[:id])
  end

  # POST /e_books
  def create
    @e_book = EBook.new(params[:e_book])
    cookies[:token] = params[:token]

    respond_to do |format|
      if params[:token]=='zwyxyz' and @e_book.save
        format.html { redirect_to @e_book, notice: 'E book was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /e_books/1
  def update
    @e_book = EBook.find(params[:id])
    cookies[:token] = params[:token]

    respond_to do |format|
      if params[:token]=='zwyxyz' and @e_book.update_attributes(params[:e_book])
        format.html { redirect_to @e_book, notice: 'E book was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
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
end
