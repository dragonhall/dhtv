# frozen_string_literal: true

server '87.229.7.176', user: 'showtime', roles: %w[app db web], port: 15_412

set :branch, ENV.fetch('DEPLOY_BRANCH') { 'master' }.to_sym

set :nginx_sites_available_path, '/opt/nginx-with-rtmp/conf/sites-available'
set :nginx_sites_enabled_path, '/opt/nginx-with-rtmp/conf/sites-enabled'

set :nginx_server_name, 'tv.dragonhall.hu'

set :ssh_options, keys: %W[#{ENV['HOME']}/.ssh/id_rsa], auth_methods: %w[publickey] # , verbose: :debug

set :branch, ENV.fetch('DEPLOY_BRANCH') { 'master' }.to_sym
