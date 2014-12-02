# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick-search/version'

Gem::Specification.new do |spec|
  spec.name          = 'quick-search'
  spec.version       = Quick::Search::VERSION
  spec.authors       = ['Fábio D. Batista']
  spec.email         = ['fabio.david.batista@gmail.com']
  spec.summary       = %q{A quick search concern for ActiveRecord and Mongoid models}
  spec.description   = %q{This gem was extracted from Elementar projects.}
  spec.homepage      = 'https://github.com/elementar/quick-search'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '< 2.0'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3.1'

  spec.add_development_dependency 'activerecord', '~> 4.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'

  spec.add_development_dependency 'mongoid', '~> 4.0'
end
