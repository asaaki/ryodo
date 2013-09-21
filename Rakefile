# encoding: utf-8

require "rubygems"
require "bundler"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require "rake"
require "jeweler"
require "rspec"
require "rspec/core/rake_task"

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ryodo"
  gem.homepage = "http://github.com/asaaki/ryodo"
  gem.license = "MIT"
  gem.summary = %Q{ryōdo【領土】 りょうど — A domain name parser using public suffix list}
  gem.description = %Q{ryōdo【領土】 りょうど — A domain name parser gem using public suffix list (provided by publicsuffix.org/mozilla)}
  gem.email = "chris@dinarrr.com"
  gem.authors = ["Christoph Grabo"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc "Starts IRB with gem loaded"
task :irb do
  sh "irb -I lib -r ryodo"
end

desc "Starts PRY with gem loaded"
task :pry do
  sh "pry -I lib -r ryodo --no-pager"
end

desc "Run all specs"
task RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

desc "Fetch and save public suffix data (task for updates)"
task :fetch_data do
  $: << "lib"
  require "ryodo"
  require "ryodo/suffix_list_fetcher"
  Ryodo::SuffixListFetcher.fetch_and_save!
end

task :default => :spec
