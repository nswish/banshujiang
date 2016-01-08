#-*- encoding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_and_redirect_to_new_domain
	before_filter :check_session_expiration

	private
	def check_session_expiration
		session[:last_seen] = Time.now
	end

	def require_login
	end

	def check_and_redirect_to_new_domain
    puts request.inspect
  end
end
