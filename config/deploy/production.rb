# frozen_string_literal: true

server 'szeroka.dragonhall.hu', user: 'showtime', roles: %w[app db web], port: 15_412
#server '79.172.195.48', user: 'showtime', roles: %w[app db web], port: 22

set :branch, ENV.fetch('DEPLOY_BRANCH', 'master').to_sym

set :nginx_sites_available_path, '/opt/nginx-with-rtmp/conf/sites-available'
set :nginx_sites_enabled_path, '/opt/nginx-with-rtmp/conf/sites-enabled'

set :nginx_server_name, 'tv.dragonhall.hu'

set :ssh_options, keys: %W[#{ENV['HOME']}/.ssh/id_rsa], auth_methods: %w[publickey] # , verbose: :debug

set :branch, ENV.fetch('DEPLOY_BRANCH', 'master').to_sym
