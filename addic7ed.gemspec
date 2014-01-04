$:.push File.expand_path('../lib', __FILE__)

require 'rake'
require 'date'
require 'addic7ed/version'

Gem::Specification.new do |s|
  s.name        = 'addic7ed'
  s.version     = Addic7ed::VERSION
  s.date        = Date.today.to_s
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Addic7ed auto-downloader"
  s.description = "Ruby script (cli) to fetch subtitles on Addic7ed"
  s.authors     = ["Michael Baudino"]
  s.email       = 'michael.baudino@alpine-lab.com'
  s.homepage    = 'https://github.com/michaelbaudino/addic7ed-ruby'

  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
  s.add_development_dependency('webmock')

  s.add_runtime_dependency('nokogiri')

  s.executables = ['addic7ed']
  s.files       = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'spec/**/*'].to_a
  s.test_files  = Dir.glob('spec/*_spec.rb')
  s.require_paths = ['lib']
  s.has_rdoc    = false
  s.license     = 'MIT'
end
