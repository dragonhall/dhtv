server '94.199.181.111', user: 'showtime', roles: %w[app db web], port: 15_412

set :nginx_sites_available_path, '/opt/nginx-with-rtmp/conf/sites-available'
set :nginx_sites_enabled_path, '/opt/nginx-with-rtmp/conf/sites-enabled'

set :deploy_to, '/srv/www/tv.teszt.dragonhall.hu/htdocs'
set :nginx_server_name, 'tv.teszt.dragonhall.hu'
set :branch, ENV.fetch('DEPLOY_BRANCH') { 'develop' }.to_sym

set :ssh_options, keys: %W[#{ENV['HOME']}/.ssh/id_rsa], auth_methods: %w[publickey] #, verbose: :debug

