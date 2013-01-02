#-*- encoding: utf-8 -*-
require 'bcrypt'
class User < ActiveRecord::Base
  attr_accessible :email, :name, :provider, :uid
	attr_accessible :password, :password_confirmation, :kind, :score, :age, :ip
	attr_accessor :password_confirmation

	@registering = false

	# validation
	with_options :if => '@registering' do |user|
		user.validates_presence_of :email, :message => "电子邮箱必须填写"
		user.validates_format_of :email, :with => /^([a-zA-Z0-9_\.-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/, :message => "请输入正确的邮箱地址"
		user.validates_uniqueness_of :email, :case_sensitive => false, :message => '此邮箱已经注册'

		user.validates :password, :presence => { :message => "登陆密码必须填写" }
		user.validates :password, :length => { :in => 6..18, :message => "登陆密码的长度须在6位到18位之间"}
		user.validates :password, :confirmation => { :message => "两次密码不匹配" }

		user.validates :age, :presence => { :message => "请选择出生年代" }
	end

	include BCrypt

	def password
		return @password_raw if @registering

    return @password ||= Password.new(password_hash)
  end

  def password=(new_password)
		@password_raw = new_password
    @password = Password.create(new_password)
    self.password_hash = @password
  end

	def register
		@registering = true

		self.name = self.email
		self.score = 10
		self.kind = '普通用户'
		self.save
	end

	def login
		@logining = true
	end

  def User.auth(name, password_raw)
    user = User.where(:name => name).first
	
		unless user then
			raise '登录失败，请确认是否输入正确的邮箱地址'
		end

		if user.password == password_raw then
			return user
		else
			raise '登录失败，密码输入错误'
		end
  end
end
