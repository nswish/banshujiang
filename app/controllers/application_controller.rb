#-*- encoding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :redirect_to_new_domain
	before_filter :check_session_expiration

  NEW_DOMAIN = 'www.banshujiang.cn'

	private
	def check_session_expiration
		session[:last_seen] = Time.now
	end

	def require_login
	end

  # 域名转移
	def redirect_to_new_domain
    if request.method == 'GET' && (request.env['SERVER_NAME'] =~ Regexp.new(Regexp.escape(NEW_DOMAIN), true)) == nil
      redirect_to "http://#{NEW_DOMAIN}#{request.fullpath}", :status => :moved_permanently
    end
  end
end
