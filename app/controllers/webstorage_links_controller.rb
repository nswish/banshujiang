#-*- encoding:utf-8 -*-
class WebstorageLinksController < ApplicationController
  def destroy
    msg = ''
    if cookies[:token] == 'zwyxyz' then
      WebstorageLink.find(params[:id]).delete
      msg = '链接已删除！'
    end
    
    redirect_to :back, notice: msg
  end

  def create
    msg = ''
    if cookies[:token] == 'zwyxyz' then
      webstorage_link = WebstorageLink.new(params[:webstorage_link])
      webstorage_link.e_book_id = params[:e_book_id]
      webstorage_link.save
      msg = "新增了#{webstorage_link.name}的链接！"
    end

    redirect_to :back, notice: msg
  end
end
