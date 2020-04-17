if Rails.env.development? or Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
