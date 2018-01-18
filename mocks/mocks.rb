# frozen_string_literal: true

require "webmock"

module Addic7ed
  module Mocks
    WELCOME_MESSAGE = <<~WELCOME_MESSAGE
      Welcome to the mocked mode.
      All network requests are forbidden (like in test mode).
      An Addic7ed page is mocked for your convenience for 🛡  Game Of Thrones ⚔️  s06e09 🐲
      Try this:
          episode = Addic7ed::Episode.new(show: "Game of Thrones", season: 6, number: 9)
          episode.subtitles
          episode.sutitles.completed.for_language(:fr).most_popular
    WELCOME_MESSAGE

    def self.included(base)
      base.send(:include, WebMock::API)
      WebMock.enable!
      mock_addic7ed(path: "/", response: "home")
      mock_addic7ed(path: "/serie/Game_of_Thrones/6/9/0", response: "got690")
      puts WELCOME_MESSAGE
    end

    def self.mock_addic7ed(path:, response:)
      stub_request(
        :get,
        URI.join("http://www.addic7ed.com/", path)
      ).to_return(response_content(response))
    end

    def self.response_content(response)
      File.new(File.join(__dir__, "#{response}.http"))
    end
  end
end

include Addic7ed::Mocks
