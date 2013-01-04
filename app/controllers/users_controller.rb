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
			redirect_to back_url
		rescue Exception => ex
			flash[:notice] = ex.message
			render :login
		end
	end

  def logout
    request.reset_session
    redirect_to :back
  end
end
