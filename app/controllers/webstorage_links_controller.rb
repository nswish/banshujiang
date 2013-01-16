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
      webstorage_link.name = webstorage_name webstorage_link.url
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
    params[:webstorage_link][:name] = webstorage_name params[:webstorage_link][:url]
    
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

  def show_to_link
  end

	def to_link
    link = WebstorageLink.find params[:id]
    redirect_to 'http://adf.ly/2960050/banner/' + link.url
	end

  private 
  def webstorage_name(url)
    if url =~ /pan\.baidu\.com/ then
      return '百度网盘'
    elsif url =~ /www\.asuswebstorage\.com/ then
      return '华硕网盘'
    elsif url =~ /www\.box\.com/ then
      return 'Box.com'
    else
      return '地址'
    end
  end
end
