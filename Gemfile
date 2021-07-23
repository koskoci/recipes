source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'rails', '~> 6.1.4'
gem 'puma', '~> 5.0'
gem 'pg'

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
end

group :development do
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'capybara'
end
