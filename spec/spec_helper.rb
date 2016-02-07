unless RUBY_ENGINE == 'rbx'
  require 'coveralls'
  Coveralls.wear!
end

require 'webmock/rspec'
require 'pry'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.raise_errors_for_deprecations!

  config.before(:each) do
    stub_request(:get, "http://www.addic7ed.com").to_return(File.new("spec/responses/homepage.http"))
  end
end
