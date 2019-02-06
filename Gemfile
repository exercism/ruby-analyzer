source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rake'
gem 'json'
gem 'activesupport'

group :test do
  gem 'minitest', '~> 5.10', '!= 5.10.2'
  gem 'minitest-stub-const'
  gem 'mocha'
end
