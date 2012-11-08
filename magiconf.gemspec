# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magiconf/version'

Gem::Specification.new do |gem|
  gem.name          = 'magiconf'
  gem.version       = Magiconf::VERSION
  gem.author       = 'Seth Vargo'
  gem.email         = 'sethvargo@gmail.com'
  gem.description   = %q{Magiconf is a tiny gem for managing a Rails application configuration file}
  gem.summary       = %q{Manage a single Rails application config file with Magiconf}
  gem.homepage      = 'https://github.com/sethvargo/magiconf'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
end
