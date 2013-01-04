#-*- encoding:utf-8 -*-
class WebstorageLinksController < ApplicationController
	before_filter :require_login, :only => [:to_link]

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

  def edit
#    raise Exception.new(params)
    @e_book = EBook.find params[:e_book_id]
    @webstorage_link = WebstorageLink.find params[:id]
  end

  def update
    @webstorage_link = WebstorageLink.find params[:id]
    
    if cookies[:token]=='zwyxyz' and @webstorage_link.update_attributes(params[:webstorage_link])
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>params[:e_book_id]), notice: '更新成功！'
    else
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>params[:e_book_id]), notice: '更新失败！'
    end
  end

  def adfly_shorten
=begin
    require 'net/http'

    url = params[:url]
    advert_type = 'int'

    ad_link = "http://api.adf.ly/api.php?key=34dd18483add2804990269bf458a83cf&uid=2960050&advert_type=#{advert_type}&domain=adf.ly&url=#{url}"

    respond_to do |format|
      format.json do
        result = {}
        begin
          result['ad_link'] = Net::HTTP.get(URI ad_link)
        rescue Exception => ex
          result['ad_link'] = ex.message
        end
        render json: result 
      end
    end
=end
  end

	def to_link
    user = User.find session[:user_id]
    ebook = EBook.find params[:e_book_id]

    unless user.has_download_priviledge? ebook then
      unless user.add_download_priviledge ebook then
        redirect_to :controller=>:users, :action=>:about_score
        return
      end
    end

    link = WebstorageLink.find params[:id]
    redirect_to 'http://adf.ly/2960050/banner/' + link.url
	end
end
