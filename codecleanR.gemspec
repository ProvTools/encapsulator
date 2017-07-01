# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "codecleanR/version"

Gem::Specification.new do |spec|
  spec.name          = "codecleanR"
  spec.version       = CodecleanR::VERSION
  spec.authors       = ["Thomas Pasquier"]
  spec.email         = ["tfjmp@seas.harvard.edu"]

  spec.summary       = %q{CodecleanR for R.}
  spec.description   = %q{Clean messy R code.}
  spec.homepage      = "https://github.com/tfjmp/codecleanR"

  spec.add_runtime_dependency "rgl", ">= 0.5.3"
  spec.add_runtime_dependency "rinruby", ">= 2.0.3"
  spec.add_runtime_dependency "json", ">= 2.1.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  spec.bindir        = "bin"
  spec.executables   = ["codecleanR"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
