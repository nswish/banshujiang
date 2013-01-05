class UserMailer < ActionMailer::Base
  default from: "nswish.ebook@gmail.com"

  def forget_password
    mail :to=>'gulei@baosight.com', :subject=>'test'
  end
end
