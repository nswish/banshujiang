class EBooksController < ApplicationController
  # GET /e_books
  # GET /e_books.json
  def index
    @e_books = EBook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @e_books }
    end
  end

  # GET /e_books/1
  # GET /e_books/1.json
  def show
    @e_book = EBook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @e_book }
    end
  end

  # GET /e_books/new
  # GET /e_books/new.json
  def new
    @e_book = EBook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @e_book }
    end
  end

  # GET /e_books/1/edit
  def edit
    @e_book = EBook.find(params[:id])
  end

  # POST /e_books
  # POST /e_books.json
  def create
    @e_book = EBook.new(params[:e_book])

    respond_to do |format|
      if @e_book.save
        format.html { redirect_to @e_book, notice: 'E book was successfully created.' }
        format.json { render json: @e_book, status: :created, location: @e_book }
      else
        format.html { render action: "new" }
        format.json { render json: @e_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /e_books/1
  # PUT /e_books/1.json
  def update
    @e_book = EBook.find(params[:id])

    respond_to do |format|
      if @e_book.update_attributes(params[:e_book])
        format.html { redirect_to @e_book, notice: 'E book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @e_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /e_books/1
  # DELETE /e_books/1.json
  def destroy
    @e_book = EBook.find(params[:id])
    @e_book.destroy

    respond_to do |format|
      format.html { redirect_to e_books_url }
      format.json { head :no_content }
    end
  end
end
