#-*- encoding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :check_session_expiration, :access_trace

	private
	def check_session_expiration
		if !session[:last_seen] || session[:last_seen] < 15.minutes.ago then
			request.reset_session
		end
		session[:last_seen] = Time.now
	end

	def require_login
		unless session[:user_id] then
			redirect_to url_for(:controller=>:users, :action=>:login), :notice => '请先登录'
		end
	end

  private
  def access_trace
  end
end
