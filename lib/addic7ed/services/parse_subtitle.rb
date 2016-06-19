require 'nokogiri'

module Addic7ed
  class ParseSubtitle
    include Service

    attr_reader :subtitle_node

    def initialize(subtitle_node)
      @subtitle_node = subtitle_node
    end

    def call
      Addic7ed::Subtitle.new(
        version:   extract_version(subtitle_node),
        language:  extract_language(subtitle_node),
        status:    extract_status(subtitle_node),
        url:       extract_url(subtitle_node),
        source:    extract_source(subtitle_node),
        hi:        extract_hi(subtitle_node),
        downloads: extract_downloads(subtitle_node),
        comment:   extract_comment(subtitle_node)
      )
    end

  private

    def extract_version(subtitle_node)
      version_node = subtitle_node.css('.NewsTitle').first
      raise Addic7ed::ParsingError unless version_node
      version_node.content
    end

    def extract_language(subtitle_node)
      language_node = subtitle_node.css('.language').first
      raise Addic7ed::ParsingError unless language_node
      language_node.content.gsub(/\A\W*/, '').gsub(/[^\w\)]*\z/, '')
    end

    def extract_status(subtitle_node)
      status_node = subtitle_node.css('tr:nth-child(3) td:nth-child(4) b').first
      raise Addic7ed::ParsingError unless status_node
      status_node.content.strip
    end

    def extract_url(subtitle_node)
      url_node = subtitle_node.css('a.buttonDownload').last
      raise Addic7ed::ParsingError unless url_node
      'http://www.addic7ed.com' + url_node['href']
    end

    def extract_source(subtitle_node)
      source_node = subtitle_node.css('tr:nth-child(3) td:first-child a').first
      source_node['href'] if source_node
    end

    def extract_hi(subtitle_node)
      hi_node = subtitle_node.css('tr:nth-child(4) td.newsDate').children[1]
      raise Addic7ed::ParsingError unless hi_node
      !hi_node.attribute("title").nil?
    end

    def extract_downloads(subtitle_node)
      downloads_node = subtitle_node.css('tr:nth-child(4) td.newsDate').first
      raise Addic7ed::ParsingError unless downloads_node
      /(?<downloads>\d*) Downloads/.match(downloads_node.content)[:downloads]
    end

    def extract_comment(subtitle_node)
      comment_node = subtitle_node.css('tr:nth-child(2) td.newsDate').first
      raise Addic7ed::ParsingError unless comment_node
      comment_node.content.gsub(/<img[^>]+\>/i, "")
    end
  end
end
