#-*- encoding:utf-8 -*-
class LanguageController < ApplicationController
  layout 'e_books'

  LIMIT_PER_PAGE = 10

  def show
    page
  end

  def page
    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end

    @title = "[#{params[:name]}]第#{@page_id}页"

    offset = (@page_id - 1) * LIMIT_PER_PAGE

    condition = { language: params[:language] }

    @e_books = EBook.where(condition).order('id desc').limit(LIMIT_PER_PAGE).offset(offset)

    @page_count = (EBook.where(condition).count / LIMIT_PER_PAGE.to_f).ceil

    render 'show.html.erb'
  end

end