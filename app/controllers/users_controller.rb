#-*- encoding: utf-8 -*-
class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(params[:user])
		back_url = flash[:http_referer] = flash[:http_referer]

    if @user.register
			session[:user_id] = @user.id
			redirect_to back_url
		else
			render :register 
		end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :root }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

	def register
		unless flash[:http_referer] then
			flash[:http_referer] = env["HTTP_REFERER"]
		else
			flash[:http_referer] = flash[:http_referer]
		end
		@user = User.new
	end

	def login
		unless flash[:http_referer] then
			flash[:http_referer] = env["HTTP_REFERER"]
		else
			flash[:http_referer] = flash[:http_referer]
		end
		@user = User.new
	end

	def auth
		name = email = params[:email]
		password_raw = params[:password]
		back_url = flash[:http_referer] = flash[:http_referer]

		begin
			@user = User.auth name, password_raw
			session[:user_id] = @user.id
			redirect_to back_url.blank? ? :root : back_url
		rescue Exception => ex
			flash[:notice] = ex.message
			render :login
		end
	end

  def logout
    request.reset_session
    redirect_to :back
  end

  def forget_password
  end

  def send_password_reset_mail
    begin
      user = User.where(:email => params[:email]).first!
      user.reset_token = rand(10**6).to_s
      user.save
      UserMailer.forget_password(user).deliver
    rescue
      redirect_to :back, :notice=>'此邮箱未注册'
    end
  end

  def show_reset_password
    begin
      user = User.find params[:id]
      unless params[:reset_token].blank? || user.reset_token == params[:reset_token] then
        redirect_to :root
      end
      @user = user
    rescue
      redirect_to :root
    end
  end

  def reset_password
    user = User.find params[:user][:id]

    if params[:password] == params[:password_confirm] then
      user.password = params[:password]
      user.reset_token = ''
      user.save
      redirect_to :root
    else
      redirect_to :back, :notice=>'两次密码不匹配'
    end
  end
end
