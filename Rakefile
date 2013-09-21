# coding: utf-8
require "rubygems"
require "bundler"
Bundler.setup(:default, :development)
require "rspec/core/rake_task"
require "bundler/gem_tasks"


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
