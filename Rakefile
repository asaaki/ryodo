require "rspec/core/rake_task"
require "bundler/gem_tasks"

desc "Starts PRY with gem loaded"
task :pry do
  sh "pry -I lib -r ryodo --no-pager"
end

desc "Run all specs"
task RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
end

namespace :spec do
  desc "Fetch mozilla_effective_tld_names.dat for specs"
  task :fetch_data do
    system "wget http://mxr.mozilla.org/mozilla-central/source/netwerk/dns/effective_tld_names.dat\?raw\=1 -O spec/_files/mozilla_effective_tld_names.dat"
  end
end

desc "Fetch and save public suffix data (task for updates)"
task :fetch_data do
  $LOAD_PATH << "lib"
  require "ryodo"
  require "ryodo/suffix_list_fetcher"
  Ryodo::SuffixListFetcher.fetch_and_save!
end

task default: :spec
