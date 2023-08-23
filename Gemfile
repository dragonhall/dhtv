# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

git_source(:bitbucket) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://bitbucket.org/#{repo_name}.git"
end

def guard(plugins = {})
  gem 'guard'
  plugins.each_pair do |name, version|
    if version == :latest
      gem "guard-#{name}", require: false
    else
      gem "guard-#{name}", version, require: false
    end
  end
end

gem 'mysql2', '>= 0.3.18'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'puma', '5.6.4'


# gem 'rails', '~> 5.2', '>= 5.2.7.1'
gem 'rails', '~> 6.1', '>= 6.1.7.5'

group :assets do
  gem 'bulma-rails'
  gem 'coffee-rails', '~> 5.0', '>= 5.0.0'
  gem 'font-awesome-rails', '>= 4.7.0.8'
  gem 'jbuilder', '~> 2.11', '>= 2.11.5'
  # gem 'jquery-rails'
  gem 'jquery-ui-rails', '>= 6.0.1'
  gem 'sass-rails', '~> 6.0', '>= 6.0.0'
  gem 'uglifier', '>= 1.3.0'
end

# Use Capistrano for deployment

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'capistrano-linked-files', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano3-puma', '>= 5.0.4', require: false
  gem 'rvm1-capistrano3', require: false

  gem 'fuubar'
  gem 'meta_request', '>= 0.7.4'
  gem 'pry-rails'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console', '>= 3.7.0'

  guard rails: :latest,
        spring: :latest,
        rspec: :latest,
        cucumber: :latest,
        bundler: :latest,
        rake: :latest
end

group :test do
  gem 'cucumber-rails', '>= 2.5.1', require: false
  gem 'factory_girl_rails', '>= 4.9.0'
  gem 'rspec-rails', '>= 6.0.2'
  gem 'rubocop'
  gem 'rubocop-rails', '>= 2.18.0'
  gem 'simplecov'
end

group :application do
  gem 'dalli', '>= 3.2.3'
  gem 'haml-rails', '>= 2.0.1'
  gem 'inherited_resources', '>= 1.13.1'
  gem 'kaminari'

  gem 'rails-i18n', '>= 7.0.7'
  gem 'rollbar'
  # gem 'simple_form'

  # gem 'ads-rails', '>= 5.1.0'
  gem 'google-analytics-rails'
end
