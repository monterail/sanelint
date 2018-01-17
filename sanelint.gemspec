# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sanelint/version'

Gem::Specification.new do |spec|
  spec.name          = "sanelint"
  spec.version       = Sanelint::VERSION
  spec.authors       = ["Michał Simka"]
  spec.email         = ["michal.simka@monterail.com"]

  spec.summary       = %q{Gem to encapsulate Monterail's company-wide rubocop setup.}
  spec.description   = %q{Gem to encapsulate Monterail's company-wide rubocop setup.}
  spec.homepage      = "https://github.com/monterail/sanelint"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubocop", "~> 0.49.1"
  spec.add_runtime_dependency "rubocop-rspec", "~> 1.16.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
