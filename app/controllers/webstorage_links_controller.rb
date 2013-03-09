#-*- encoding:utf-8 -*-
class WebstorageLinksController < ApplicationController
  DOWNLOAD_COUNT_LIMIT = 10
  DOWNLOAD_HOUR_LIMIT  = 12
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
  
    # 按客户端屏蔽 显示
    if session[:download_time_array] && session[:download_time_array].length >= DOWNLOAD_COUNT_LIMIT then
      @remain_time = (session[:download_time_array].first - DOWNLOAD_HOUR_LIMIT.hours.ago) * 1000
      return
    end

    # 按ip屏蔽 显示
    ip = request.env['HTTP_X_FORWARDED_FOR']
    counts = IpDownload.where(:created_at=>[DOWNLOAD_HOUR_LIMIT.hours.ago..DateTime.now], :ip=>ip).count

    if counts >= DOWNLOAD_COUNT_LIMIT then
      ip_download = IpDownload.where(:created_at=>[DOWNLOAD_HOUR_LIMIT.hours.ago..DateTime.now], :ip=>ip).order('created_at').first
      @remain_time = (ip_download.created_at - DOWNLOAD_HOUR_LIMIT.hours.ago) * 1000
      return
    end
  end

	def to_link
    # 按客户端屏蔽
    if !session[:download_time_array] then !session[:download_time_array] = [] end
    while session[:download_time_array].length > 0 && session[:download_time_array].first < DOWNLOAD_HOUR_LIMIT.hours.ago
      session[:download_time_array].shift
    end

    if session[:download_time_array].length >= DOWNLOAD_COUNT_LIMIT then
      redirect_to url_for(:controller=>:webstorage_links, :action=>:show_to_link, :e_book_id=>params[:e_book_id], :id=>params[:id]), :notice=>'您已经超过了许可下载的最大次数。'
      return
    end

    # 按ip屏蔽
    ip = request.env['HTTP_X_FORWARDED_FOR']
    e_book = EBook.find params[:e_book_id]  
    counts = IpDownload.where(:created_at=>[DOWNLOAD_HOUR_LIMIT.hours.ago..DateTime.now], :ip=>ip).count
    if counts >= DOWNLOAD_COUNT_LIMIT then
      redirect_to url_for(:controller=>:webstorage_links, :action=>:show_to_link, :e_book_id=>params[:e_book_id], :id=>params[:id]), :notice=>'您已经超过了许可下载的最大次数。'
      return
    end

    # 下载开始
    link = WebstorageLink.find params[:id]

    ebook = EBook.find params[:e_book_id] 
    ebook.download_count = ebook.download_count + 1
    ebook.save
    
    # 记录客户端下载时间
    session[:download_time_array].push Time.now

    # 记录ip下载时间
    IpDownload.create(:ip=>ip, :e_book_id=>e_book.id, :e_book_name=>e_book.name)

		redirect_to link.url
	end
  
  def match_ip_location
    require 'net/http'
    @ip_locations = IpDownload.where("ip > ' ' and location is null").order(:location).all.map do |ip_download|
      body = Net::HTTP.get(URI 'http://ip138.com/ips1388.asp?ip=101.87.159.99&action=2').force_encoding('gb2312').encode 'utf-8'
      ip_download.location = body[/本站主数据：(.*?)</].chop.split('：')[1]
      ip_download.save
      ip_download
    end
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
