source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
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

gem 'mysql2', '>= 0.3.18', '< 0.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
gem 'puma', '3.12.4'

group :assets do
  gem 'bulma-rails'
  gem 'coffee-rails', '~> 4.2'
  gem 'font-awesome-rails'
  gem 'jbuilder', '~> 2.5'
  #gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'sass-rails', '~> 5.0'
  gem 'uglifier', '>= 1.3.0'
end


# Use Capistrano for deployment

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do

  gem 'capistrano-linked-files', require: false
  gem 'capistrano-rails', require: false
  gem 'rvm1-capistrano3', require: false
  gem 'capistrano3-puma', require: false
  
  gem 'fuubar'
  gem 'meta_request'
  gem 'pry-rails'
  # Spring speeds up development by keeping your application 
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console', '>= 3.3.0'

  guard rails:   :latest,
        spring:  :latest,
        rspec:   :latest,
        cucumber: :latest,
        bundler: :latest,
        rake:    :latest
end

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', require: false
  gem 'factory_girl_rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'simplecov'
end

group :application do
  gem 'haml-rails'
  gem 'dalli'
  gem 'inherited_resources'
  gem 'kaminari'

  gem 'rails-i18n'
  gem 'rollbar'
  # gem 'simple_form'

  gem 'google-analytics-rails'
  gem 'ads-rails'
end
