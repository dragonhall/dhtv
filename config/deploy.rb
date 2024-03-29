# frozen_string_literal: true

# config valid only for current version of Capistrano
lock '~> 3.17.0'

set :application, 'dhtv'
set :repo_url, 'git@github.com:dragonhall/dhtv.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, '/srv/www/tv.dragonhall.hu'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
set :format_options, command_output: true, truncate: false, color: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, 'log',
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'public/system',
       'public/uploads',
       'public/programs',
       'public/recordings',
       'public/screenshots'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

set :rvm1_roles, :all

append :rvm_map_bins, 'gem', 'ruby', 'bundle', 'rake'

namespace :deploy do
  desc 'Run things before deploy'
  task :setup
  on roles :all do
    rvm_ver = capture('rvm --verson || true').strip

    invoke 'rvm1:install:rvm' if rvm_ver.empty?
  end
end

after 'bundler:map_bins', 'rvm1:hook'

before 'deploy:assets:precompile', 'rvm1:hook'
before 'deploy', 'deploy:setup'
before 'deploy', 'rvm1:install:ruby'
