# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ryodo/version'

Gem::Specification.new do |spec|
  project_name       = 'ryōdo【領土】 りょうど — A domain name parser'
  spec.name          = 'ryodo'
  spec.version       = Ryodo::VERSION
  spec.authors       = ['Christoph Grabo']
  spec.email         = ['chris@dinarrr.com']
  spec.description   = "#{project_name} gem using public suffix list (provided by publicsuffix.org / mozilla)"
  spec.summary       = "#{project_name} using public suffix list"
  spec.homepage      = 'http://github.com/asaaki/ryodo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{\A(test|spec|features)\/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fakeweb'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
end
