config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
    :address                =>  'smtp.gmail.com',
    :port                   =>  587,
    :domain                 =>  'ebook.jiani.info',
    :user_name              =>  'nswish.ebook',
    :password               =>  'openshift',
    :authentication         =>  'plain',
    :enable_starttls_auto   =>  true
}
