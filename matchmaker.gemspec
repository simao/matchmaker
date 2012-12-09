# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'matchmaker/version'

Gem::Specification.new do |gem|
  gem.name          = "matchmaker"
  gem.version       = Matchmaker::VERSION
  gem.authors       = ["Simão Mata"]
  gem.email         = ["simao.m@gmail.com"]
  gem.description   = %q{Pattern matching for ruby}
  gem.summary       = %q{Simple pattern matching library for ruby}
  gem.homepage      = "http://github.com/simao/matchmaker"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
