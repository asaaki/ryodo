lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ryodo/version"

Gem::Specification.new do |spec|
  spec.name          = "ryodo"
  spec.version       = Ryodo::VERSION
  spec.authors       = ["Christoph Grabo"]
  spec.email         = ["chris@dinarrr.com"]
  spec.description   = %q{ryōdo【領土】 りょうど — A domain name parser gem using public suffix list (provided by publicsuffix.org / mozilla)}
  spec.summary       = %q{ryōdo【領土】 りょうど — A domain name parser using public suffix list}
  spec.homepage      = "http://github.com/asaaki/ryodo"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler",   "~> 1.5"
  spec.add_development_dependency "coveralls", "~> 0.7.1"
  spec.add_development_dependency "rspec",     "~> 3.1.0"
  spec.add_development_dependency "fakeweb",   "~> 1.3.0"
  spec.add_development_dependency "pry",       "~> 0.10.1"
  spec.add_development_dependency "pry-doc",   "~> 0.6.0"
end
