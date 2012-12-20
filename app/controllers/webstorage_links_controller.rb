#-*- encoding:utf-8 -*-
class WebstorageLinksController < ApplicationController
  ADFLY_PREFIX = 'http://api.adf.ly/api.php?key=34dd18483add2804990269bf458a83cf&uid=2960050&advert_type=int&domain=adf.ly&url='  
  
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

  def adfly_shorten
    require 'net/http'

    url = params[:url]

    respond_to do |format|
      format.json do
        result = {}
        begin
          result['ad_link'] = Net::HTTP.get(URI ADFLY_PREFIX+url)
        rescue Exception => ex
          result['ad_link'] = ex.message
        end
        render json: result 
      end
    end
  end
end
