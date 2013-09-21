# encoding: utf-8

$:.push(File.expand_path("../../lib", __FILE__))

require "fakeweb"
require "uri"
require "ryodo"

RSpec::Matchers.define :include_hash do |expected|

  match do |actual|
    actual.is_a?(Hash) &&
    expected.is_a?(Hash) &&
    (actual.keys & expected.keys) == expected.keys &&
    !(expected.keys.inject([]){|m,k|
        m << expected.has_value?(actual[k])
      }.uniq.include?(false))
  end

end

RYODO_SPEC_ROOT = File.expand_path("..", __FILE__)
RYODO_TMP_ROOT  = File.expand_path("../../tmp/spec", __FILE__)

Dir.mkdir RYODO_TMP_ROOT unless File.exists?(RYODO_TMP_ROOT)

FakeWeb.register_uri(:get,
  Ryodo::PUBLIC_SUFFIX_DATA_URI,
  :body => File.read("#{RYODO_SPEC_ROOT}/_files/mozilla_effective_tld_names.dat")
  )

FakeWeb.register_uri(
  :get,
  "#{Ryodo::PUBLIC_SUFFIX_DATA_URI}&invalid_file",
  :body => "Oops!",
  :status => [404,"Not Found"]
  )
