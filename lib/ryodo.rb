# encoding: utf-8

module Ryodo

  VERSION_FILE = File.expand_path("../../VERSION", __FILE__)
  VERSION      = File.exist?(VERSION_FILE) ? File.read(VERSION_FILE) : "(could not find VERSION file)"

  RYODO_ROOT   = File.expand_path("../..", __FILE__)

  PUBLIC_SUFFIX_DATA_URI = "http://mxr.mozilla.org/mozilla-central/source/netwerk/dns/effective_tld_names.dat?raw=1"
  PUBLIC_SUFFIX_STORE    = "#{RYODO_ROOT}/data/suffix.dat"

end

require "ryodo/domain"
require "ryodo/parser"
require "ryodo/rule"
require "ryodo/rule_set"
require "ryodo/suffix_list"

require "ryodo/methods"
#require "ryodo/ext/string"
#require "ryodo/ext/uri"

# Convenient shorthands
module Ryodo
  extend Ryodo::Methods
  require "ryodo/convenience"
end
#require "ryodo/convenience/utf8"
