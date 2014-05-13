# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puggle/version'

Gem::Specification.new do |spec|
  spec.name          = "puggle"
  spec.version       = Puggle::VERSION
  spec.authors       = ["Anders Törnqvist"]
  spec.email         = ["anders@pugglepay.com"]
  spec.summary       = %q{Nice stuff to have}
  spec.description   = %q{Nice stuff to have}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "colorize", "~> 0.6"
  spec.add_runtime_dependency "activesupport", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 2.14"
end
