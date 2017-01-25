# frozen_string_literal: true
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

desc 'Run all specs'
task RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

namespace :spec do
  desc 'Fetch mozilla_effective_tld_names.dat for specs'
  task :fetch_data do
    source_url = 'https://publicsuffix.org/list/effective_tld_names.dat'
    output = 'spec/_files/mozilla_effective_tld_names.dat'
    system "wget '#{source_url}?raw=1' -O #{output}"
  end

  desc 'Run match check script'
  task :check do
    success = system('bundle exec spec/suffix_checker.rb')
    exit(success)
  end
end

desc 'Fetch and save public suffix data (task for updates)'
task :fetch_data do
  $LOAD_PATH << 'lib'
  require 'ryodo'
  require 'ryodo/suffix_list_fetcher'
  Ryodo::SuffixListFetcher.fetch_and_save!
end

task default: %i(spec spec:check)
