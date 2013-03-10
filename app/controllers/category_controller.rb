#-*- encoding:utf-8 -*-
class CategoryController < ApplicationController
	layout 'e_books'

	LIMIT_PER_PAGE = 10

  def show
		page
  end

  def page
  puts params
    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end

    @title = "[#{params[:name]}]第#{@page_id}页"

    offset = (@page_id - 1) * LIMIT_PER_PAGE

    condition = {}
    condition[:id] = Attr.where(:name=>params[:category]).first.e_book_attrs.where(:value=>params[:name]).collect do |ebookattr|
      ebookattr.e_book_id
    end

    @e_books = EBook.where(condition).order('created_at desc').limit(LIMIT_PER_PAGE).offset(offset)

    @page_count = (EBook.where(condition).count / LIMIT_PER_PAGE.to_f).ceil

    render 'show.html.erb'
  end

	def bbs
    attr_id = Attr.where(:name=>params[:category]).first.id
    @e_books = EBookAttr.includes(:e_book).where(:attr_id=>attr_id, :value=>params[:name]).map do |e_book_attr|
      e_book_attr.e_book
    end
    @e_books.sort! { |a,b| a.id <=> b.id }
	end

end
