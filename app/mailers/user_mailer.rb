#-*- encoding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: "\"搬书匠\" <#{Rails.configuration.action_mailer.smtp_settings[:from_mail]}>"

  def forget_password(user)
    @user = user
    mail :to => user.email, :subject => '用户密码重置邮件'
  end
end
