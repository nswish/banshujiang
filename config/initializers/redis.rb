require'redis'

host = ENV['OPENSHIFT_APP_DNS'] ? 'pub-redis-15953.us-east-1-3.7.ec2.redislabs.com' : 'localhost'
port = ENV['OPENSHIFT_APP_DNS'] ? 15953 : 6379
password = ENV['OPENSHIFT_APP_DNS'] ? 'iz1MegAGA0szrwdx' : 'zwyxyz'

Redis.current = Redis.new :host=>host, :port=>port, :password=>password
