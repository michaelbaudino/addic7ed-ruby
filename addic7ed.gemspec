$:.push File.expand_path("../lib", __FILE__)

require "addic7ed/version"

Gem::Specification.new do |s|
  s.name        = "addic7ed"
  s.version     = Addic7ed::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Addic7ed auto-downloader"
  s.description = "Ruby script (cli) to fetch subtitles on Addic7ed"
  s.authors     = ["Michael Baudino"]
  s.email       = "michael.baudino@alpine-lab.com"
  s.homepage    = "https://github.com/michaelbaudino/addic7ed-ruby"

  s.add_development_dependency("rspec")
  s.add_development_dependency("rake")
  s.add_development_dependency("webmock")
  s.add_development_dependency("pry")

  s.add_runtime_dependency("oga",  "~> 2.7")
  s.add_runtime_dependency("json", "~> 1.8.3")

  s.executables = ["addic7ed"]
  s.files       = `git ls-files -- lib/* LICENSE.md`.split("\n")
  s.test_files  = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.has_rdoc    = false
  s.license     = "MIT"
end
