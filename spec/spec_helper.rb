# frozen_string_literal: true

require 'fileutils'
require 'uri'
require 'ryodo'
require 'webmock/rspec'

RYODO_SPEC_ROOT = File.expand_path(__dir__)
RYODO_TMP_ROOT  = File.expand_path('../tmp/spec', __dir__)
FileUtils.mkdir_p(RYODO_TMP_ROOT)
