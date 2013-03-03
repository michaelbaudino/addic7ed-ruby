lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rake'
require 'date'
require 'addic7ed'

Gem::Specification.new do |s|
  s.name        = 'addic7ed'
  s.version     = Addic7ed::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Addic7ed auto-downloader"
  s.description = "Ruby script (cli) to fetch subtitles on Addic7ed"
  s.authors     = ["Michael Baudino"]
  s.email       = 'michael.baudino@alpine-lab.com'
  s.homepage    = 'https://github.com/michaelbaudino/addic7ed-ruby'
  s.executables = ['addic7ed']
  s.files       = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
  s.has_rdoc    = false
  s.license     = 'MIT'
  s.test_files  = Dir.glob('spec/*_spec.rb')

  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
  s.add_dependency('bundler')
end
