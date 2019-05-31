# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'sgas/sgas'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'sgas-rails'
  s.version     = Sgas::VERSION
  s.authors     = ['Gregory DALMAR']
  s.email       = ['contact@atomgrafiks.com']
  s.homepage    = 'http://github.com/AtomGrafiks/sgas-rails'
  s.summary     = 'Summary of Sgas.'
  s.description = 'Rails implementation of SGAS Auth Service'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 6.0.0.rc1'
  s.add_dependency 'faraday', '~> 0.15'
end
