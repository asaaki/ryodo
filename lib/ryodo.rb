# frozen_string_literal: true

require 'ryodo/version'
require 'ryodo/domain'
require 'ryodo/parser'
require 'ryodo/rule'
require 'ryodo/rule_set'
require 'ryodo/suffix_list'
require 'ryodo/methods'

module Ryodo
  RYODO_ROOT = File.expand_path('..', __dir__)
  PUBLIC_SUFFIX_DATA_URI = 'https://publicsuffix.org/list/public_suffix_list.dat'
  PUBLIC_SUFFIX_STORE = "#{RYODO_ROOT}/data/suffix.dat"

  extend Ryodo::Methods
end
