#-*- encoding: utf-8 -*-
class EBooksController < ApplicationController
  # GET /e_books
  def index
    @e_books = EBook.all
    @title = '电子书(EBook)下载'

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /e_books/1
  def show
    @e_book = EBook.find(params[:id])
    @title = "[#{@e_book.name}].#{@e_book.publish_year}.#{@e_book.language}版.#{@e_book.format}"

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /e_books/new
  def new
    @e_book = EBook.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /e_books/1/edit
  def edit
    @e_book = EBook.find(params[:id])
  end

  # POST /e_books
  def create
    @e_book = EBook.new(params[:e_book])

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
