require 'nokogiri'
require 'net/http'
require 'open-uri'

module Addic7ed
  class Parser

    def initialize(episode, lang)
      @episode, @lang = episode, lang
      @subtitles = []
    end

    def extract_subtitles
      @dom = subtitles_page_dom
      check_subtitles_presence
      parse_subtitle_nodes_list
      @subtitles
    end

  protected

    def subtitles_page_dom
      response = Net::HTTP.get_response(URI(@episode.url(@lang)))
      raise EpisodeNotFound unless response.body
      Nokogiri::HTML(response.body)
    end

    def check_subtitles_presence
      raise NoSubtitleFound unless @dom.css('select#filterlang ~ font[color="yellow"]').empty?
    end

    def parse_subtitle_nodes_list
      sublist_node = @dom.css('#container95m table.tabel95 table.tabel95')
      raise NoSubtitleFound if sublist_node.size == 0
      sublist_node.each do |sub_node|
        @subtitles << parse_subtitle_node(sub_node)
      end
    end

    def parse_subtitle_node(sub_node)
      Addic7ed::Subtitle.new(
        version:   extract_version(sub_node),
        language:  extract_language(sub_node),
        status:    extract_status(sub_node),
        url:       extract_url(sub_node),
        source:    extract_source(sub_node),
        hi:        extract_hi(sub_node),
        downloads: extract_downloads(sub_node),
        comment:   extract_comment(sub_node)
      )
    end

    def extract_version(sub_node)
      version_node = sub_node.css('.NewsTitle').first
      raise Addic7ed::ParsingError unless version_node
      version_node.content.gsub(/ \nVersion /, '').gsub(/,.*/, '')
    end

    def extract_language(sub_node)
      language_node = sub_node.css('.language').first
      raise Addic7ed::ParsingError unless language_node
      language_node.content.gsub(/\A\W*/, '').gsub(/[^\w\)]*\z/, '')
    end

    def extract_status(sub_node)
      status_node = sub_node.css('tr:nth-child(3) td:nth-child(4) b').first
      raise Addic7ed::ParsingError unless status_node
      status_node.content.strip
    end

    def extract_url(sub_node)
      url_node = sub_node.css('a.buttonDownload').last
      raise Addic7ed::ParsingError unless url_node
      'http://www.addic7ed.com' + url_node['href']
    end

    def extract_source(sub_node)
      source_node = sub_node.css('tr:nth-child(3) td:first-child a').first
      source_node['href'] if source_node
    end

    def extract_hi(sub_node)
      hi_node = sub_node.css('tr:nth-child(4) td.newsDate').children[1]
      raise Addic7ed::ParsingError unless hi_node
      !hi_node.attribute("title").nil?
    end

    def extract_downloads(sub_node)
      downloads_node = sub_node.css('tr:nth-child(4) td.newsDate').first
      raise Addic7ed::ParsingError unless downloads_node
      /(?<downloads>\d*) Downloads/.match(downloads_node.content)[:downloads]
    end

    def extract_comment(sub_node)
        comment_node = sub_node.css('tr:nth-child(2) td.newsDate').first
        raise Addic7ed::ParsingError unless comment_node
        comment_node.content.gsub(/<img[^>]+\>/i, "")
    end

  end
end
