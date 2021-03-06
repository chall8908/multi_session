$:.push File.expand_path('lib', __dir__)
require 'multi_session/version'

Gem::Specification.new do |s|
  s.name       = 'multi_session'
  s.version    = MultiSession::VERSION
  s.authors    = ['Sean Huber']
  s.email      = ['seanhuber@seanhuber.com']
  s.homepage   = 'https://github.com/seanhuber/multi_session'
  s.summary    = 'Creates multiple sessions for Rails'
  s.license    = 'MIT'
  s.files      = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 5.2.0'
  s.add_development_dependency 'coveralls', '~> 0.8'
  s.add_development_dependency 'rspec-rails'
end
