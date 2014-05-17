# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sanelint/version'

Gem::Specification.new do |spec|
  spec.name          = "sanelint"
  spec.version       = Sanelint::VERSION
  spec.authors       = ["Tymon Tobolski"]
  spec.email         = ["tymon.tobolski@monterail.com"]
  spec.summary       = %q{Sane Ruby/Rails linter.}
  spec.description   = %q{Ruby/Rails linter. Sane stuff only}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails_best_practices"
  spec.add_dependency "brakeman"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
