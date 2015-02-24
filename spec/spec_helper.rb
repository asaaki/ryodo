if ENV["TRAVIS"] || ENV["CI"]
  require "codeclimate-test-reporter"
  require "coveralls"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    CodeClimate::TestReporter::Formatter
  ]
  SimpleCov.start
end

require "fileutils"
require "fakeweb"
require "uri"
require "ryodo"

RYODO_SPEC_ROOT = File.expand_path("..", __FILE__)
RYODO_TMP_ROOT  = File.expand_path("../../tmp/spec", __FILE__)

FileUtils.mkdir_p RYODO_TMP_ROOT unless File.exist?(RYODO_TMP_ROOT)

FakeWeb.register_uri(
  :get,
  Ryodo::PUBLIC_SUFFIX_DATA_URI,
  body: File.read("#{RYODO_SPEC_ROOT}/_files/mozilla_effective_tld_names.dat")
)

FakeWeb.register_uri(
  :get,
  "#{Ryodo::PUBLIC_SUFFIX_DATA_URI}&invalid_file",
  body: "Oops!",
  status: [404, "Not Found"]
)
