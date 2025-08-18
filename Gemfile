source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mandate'
gem 'rake'
gem 'json'
gem 'activesupport'

gem 'parser'
gem 'rubocop'
gem 'rubocop-minitest'
gem 'rubocop-performance'

group :test do
  gem 'minitest'
  gem 'minitest-stub-const'
  gem 'mocha'
  gem 'simplecov', '~> 0.17.0'
end
