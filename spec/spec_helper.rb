# frozen_string_literal: true

if ENV['CI']
  require 'codeclimate-test-reporter'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    CodeClimate::TestReporter::Formatter
  ]
  SimpleCov.start
end

require 'fileutils'
require 'uri'
require 'ryodo'
require 'webmock/rspec'
# require 'fakeweb'

RYODO_SPEC_ROOT = File.expand_path(__dir__)
RYODO_TMP_ROOT  = File.expand_path('../tmp/spec', __dir__)
FileUtils.mkdir_p(RYODO_TMP_ROOT)

# stub_request(:get, Ryodo::PUBLIC_SUFFIX_DATA_URI).
#   with(body: File.read("#{RYODO_SPEC_ROOT}/fixtures/public_suffix_list.dat"))

# FakeWeb.register_uri(
#   :get,
#   Ryodo::PUBLIC_SUFFIX_DATA_URI,
#   body: File.read("#{RYODO_SPEC_ROOT}/fixtures/public_suffix_list.dat")
# )

# stub_request(:get, "#{Ryodo::PUBLIC_SUFFIX_DATA_URI}&invalid_file").
#   with(body: 'Oops!', status: 404)


# FakeWeb.register_uri(
#   :get,
#   "#{Ryodo::PUBLIC_SUFFIX_DATA_URI}&invalid_file",
#   body: 'Oops!',
#   status: [404, 'Not Found']
# )
