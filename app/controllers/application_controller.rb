#-*- encoding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :check_session_expiration

	private
	def check_session_expiration
		session[:last_seen] = Time.now
	end

	def require_login
	end
end
