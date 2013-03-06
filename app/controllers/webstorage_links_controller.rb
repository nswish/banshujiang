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
    if session[:download_time_array] && session[:download_time_array].length >= 1 then
      @remain_time = (session[:download_time_array].first.to_i - 12.hours.ago.to_i)*1000
    end
  end

	def to_link
    if !session[:download_time_array] then !session[:download_time_array] = [] end
    while session[:download_time_array].length > 0 && session[:download_time_array].first < 12.hours.ago
      session[:download_time_array].shift
    end

    if session[:download_time_array].length >= 10 then
      redirect_to url_for(:controller=>:webstorage_links, :action=>:show_to_link, :e_book_id=>params[:e_book_id], :id=>params[:id]), :notice=>'您已经超过了许可下载的最大次数。'
      return
    end

    link = WebstorageLink.find params[:id]

    ebook = EBook.find params[:e_book_id] 
    ebook.download_count = ebook.download_count + 1
    ebook.save
    
    session[:download_time_array].push Time.now

		redirect_to link.url
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
