#-*- encoding:utf-8 -*-
class WebstorageLinksController < ApplicationController
  DOWNLOAD_COUNT_LIMIT = 10
  DOWNLOAD_HOUR_LIMIT  = 10
  def destroy
    msg = ''
    if cookies[:token] == 'zwyxyz' then
      WebstorageLink.find(params[:id]).delete
      msg = '链接已删除！'
    end
    
    redirect_to :back, notice: msg
  end

  def create
    webstorage_link = WebstorageLink.new
    webstorage_link.url, webstorage_link.name, webstorage_link.secret_key = analyze_url params[:webstorage_link][:url]
    webstorage_link.e_book_id = params[:e_book_id]
    webstorage_link.save
    msg = "新增了#{webstorage_link.name}的链接！"

    redirect_to :back, notice: msg
  end

  def edit
#    raise Exception.new(params)
    @e_book = EBook.find params[:e_book_id]
    @webstorage_link = WebstorageLink.find params[:id]
  end

  def update
    @webstorage_link = WebstorageLink.find params[:id]
    @webstorage_link.url, @webstorage_link.name, @webstorage_link.secret_key = analyze_url params[:webstorage_link][:url]
    
    if cookies[:token]=='zwyxyz' and @webstorage_link.save
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>params[:e_book_id]), notice: '更新成功！'
    else
      redirect_to url_for(:controller=>:e_books, :action=>:edit, :id=>params[:e_book_id]), notice: '更新失败！'
    end
  end

  def show_to_link
    @e_book = EBook.find params[:e_book_id]
    @title = view_context.standard_file_name(@e_book) + '下载链接'
  
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
    @link = WebstorageLink.find params[:id]

    ebook = EBook.find params[:e_book_id] 
    ebook.download_count = ebook.download_count + 1
    ebook.save
    
    # 记录客户端下载时间
    session[:download_time_array].push Time.now

    # 记录ip下载时间
    IpDownload.create(:ip=>ip, :e_book_id=>e_book.id, :e_book_name=>e_book.name)

		#redirect_to link.url
    render :layout => 'application'
	end
  
  def match_ip_location
    require 'net/http'

    ip_map = {}
    @ip_locations = IpDownload.where("ip > ' ' and location is null").order(:location).all.map do |ip_download|
      last_ip = ip_download.ip.split(',')[-1].strip # 可能有多个ip地址，取最后一个
      if !ip_map[last_ip] then
        body = Net::HTTP.get(URI "http://ip138.com/ips1388.asp?ip=#{last_ip}&action=2").force_encoding('gb2312').encode 'utf-8'
        ip_map[last_ip] = body[/本站主数据：(.*?)</].chop.split('：')[1]
      end

      ip_download.location = ip_map[last_ip].split(' ')[0]
      ip_download.isp = ip_map[last_ip].split(' ')[1]
      ip_download.save

      ip_download
    end
  end

  private 
  def analyze_url(url)
    if url =~ /pan\.baidu\.com/ then
      if url =~ /密码/ then
        tokens = url.split(' ')
        return tokens[1], '百度网盘', tokens[3]
      else
        return url, '百度网盘', nil
      end
    elsif url =~ /www\.asuswebstorage\.com/ then
      return url, '华硕网盘', nil
    elsif url =~ /\.box\.com/ then
      return url, 'Box.com', nil
    elsif url =~ /mega/ then
      return url, 'Mega网盘', nil
    else
      return 'javascript:void;', '地址', nil
    end
  end
end
