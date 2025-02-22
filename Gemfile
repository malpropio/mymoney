source 'https://rubygems.org'

if ENV['CI']
  # use HTTPS with password on Travis CI
  git_source :github do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
    "https://emthomas:#{ENV.fetch('CI_USER_PASSWORD')}@github.com/#{repo_name}.git"
  end
else
  gem 'seed_dump', git: 'git@github.com:iDreamOn/seed_dump.git', branch: 'order-by-association'
end

# Add bootstrap
gem 'bootstrap-sass', '3.2.0.0'
gem 'bootstrap-datepicker-rails'

gem 'passenger'

# Help with login etc...
gem 'devise'

# Add bcrypt for password encription
gem 'bcrypt', '3.1.7'

# Create sample users
gem 'faker'

# Display long lists on multiple pages
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'

# Display charts
gem 'chartkick'
gem 'groupdate'
gem 'active_median'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Use sqlite3 as the database for Active Record
gem 'mysql2', '0.3.20'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.0'

  gem 'rack-mini-profiler'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'codecov'
  gem 'rubocop'
end

group :development do
  # needed for database diagrams
  gem 'rails-erd'
end
