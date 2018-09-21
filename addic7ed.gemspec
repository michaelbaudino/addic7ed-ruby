# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "addic7ed/version"

Gem::Specification.new do |s|
  s.name                 = "addic7ed"
  s.version              = Addic7ed::VERSION
  s.platform             = Gem::Platform::RUBY
  s.summary              = "Addic7ed auto-downloader"
  s.description          = "Ruby script (cli) to fetch subtitles on Addic7ed"
  s.authors              = ["Michael Baudino"]
  s.email                = "michael.baudino@alpine-lab.com"
  s.homepage             = "https://github.com/michaelbaudino/addic7ed-ruby"
  s.files                = `git ls-files -z lib LICENSE.md`.split("\x0")
  s.require_paths        = ["lib"]
  s.license              = "MIT"
  s.post_install_message = <<-POST_INSTALL_MESSAGE

  Important update if you're upgrading from 3.x to 4.x:

      This gem is not providing a CLI tool anymore.
      If you're using it as a Ruby API for Addic7ed, you're all good, ignore this message.
      If you're expecting the `addic7ed` binary, we've moved it to the `addic7ed-cli` gem.

  POST_INSTALL_MESSAGE

  s.add_development_dependency("inch")
  s.add_development_dependency("pry")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("rubocop")
  s.add_development_dependency("webmock")
  s.add_development_dependency("yard")

  s.add_runtime_dependency("oga", "~> 2.7")
end
