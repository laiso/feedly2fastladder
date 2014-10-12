# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feedly2fastladder'

Gem::Specification.new do |spec|
  spec.name          = "feedly2fastladder"
  spec.version       = Feedly2fastladder::VERSION
  spec.authors       = ["laiso"]
  spec.email         = ["laiso@lai.so"]
  spec.summary       = %q{Bridge for converting to the Web API response of Fast ladder from Feedly cloud.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/laiso/feedly2fastladder/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~>3.1"
end
