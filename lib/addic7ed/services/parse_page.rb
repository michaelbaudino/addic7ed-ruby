require 'nokogiri'
require 'net/http'
require 'open-uri'

module Addic7ed
  class ParsePage
    include Service

    attr_reader :uri

    def initialize(url)
      @uri = URI(url)
    end

    def call
      check_subtitles_presence!
      subtitles_nodes.map { |subtitle_node| Addic7ed::ParseSubtitle.call(subtitle_node) }
    end

  private

    def page_dom
      raise EpisodeNotFound if server_response.body.nil? || server_response.body.empty?
      @page_dom ||= Nokogiri::HTML(server_response.body)
    end

    def subtitles_nodes
      @subtitles_nodes ||= page_dom.css('#container95m table.tabel95 table.tabel95')
    end

    def server_response
      @server_response ||= Net::HTTP.start(uri.hostname, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request["User-Agent"] = USER_AGENTS.sample
        http.request(request)
      end
    end

    def check_subtitles_presence!
      raise NoSubtitleFound unless page_dom.css('select#filterlang ~ font[color="yellow"]').empty? && subtitles_nodes.size > 0
    end
  end
end
