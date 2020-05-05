# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "encapsulator/version"

Gem::Specification.new do |spec|
  spec.name          = "encapsulator"
  spec.version       = Encapsulator::VERSION
  spec.authors       = ["Thomas Pasquier", 'Matt K Lau', 'Xuehuan "Michael" Han']
  spec.email         = ["tfjmp@seas.harvard.edu"]

  spec.summary       = %q{encapsulator for R.}
  spec.description   = %q{Clean messy R code.}
  spec.homepage      = "https://github.com/tfjmp/encapsulator"

  spec.add_runtime_dependency "rgl", ">= 0.5.3"
  spec.add_runtime_dependency "rinruby", ">= 2.0.3"
  spec.add_runtime_dependency "json", ">= 2.1.0"

  spec.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  spec.bindir        = "bin"
  spec.executables   = ["encapsulator"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.3.3"
end
