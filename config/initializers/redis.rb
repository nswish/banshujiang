require'redis'

host = ENV['OPENSHIFT_INTERNAL_IP'] || 'localhost'
port = 6379
password = ENV['OPENSHIFT_APP_DNS'] ? 'iz1MegAGA0szrwdx' : 'zwyxyz'

Redis.current = Redis.new :host=>host, :port=>port, :password=>password
