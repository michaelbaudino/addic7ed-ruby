require "nokogiri"

module Addic7ed
  class ParseSubtitle
    include Service

    attr_reader :subtitle_node

    FIELDS = [:version, :language, :status, :url, :source, :hi, :downloads, :comment].freeze

    def initialize(subtitle_node)
      @subtitle_node = subtitle_node
    end

    def call
      Addic7ed::Subtitle.new(extract_fields)
    end

  private

    def extract_fields
      FIELDS.map do |field|
        { field => send(:"extract_#{field}") }
      end.reduce(:merge)
    end

    def extract_field(selector, options = { required: true })
      node = subtitle_node.css(selector).first
      raise Addic7ed::ParsingError if options[:required] && node.nil?
      yield node
    end

    def extract_version
      extract_field(".NewsTitle", &:content)
    end

    def extract_language
      extract_field(".language") do |node|
        node.content.gsub(/\A\W*/, "").gsub(/[^\w\)]*\z/, "")
      end
    end

    def extract_status
      extract_field("tr:nth-child(3) td:nth-child(4) b") do |node|
        node.content.strip
      end
    end

    def extract_url
      extract_field("a.buttonDownload:last-of-type") do |node|
        "http://www.addic7ed.com#{node['href']}"
      end
    end

    def extract_source
      extract_field("tr:nth-child(3) td:first-child a", required: false) do |node|
        node["href"] unless node.nil?
      end
    end

    def extract_hi
      extract_field("tr:nth-child(4) td.newsDate img:last-of-type") do |node|
        node.attribute("title") == "Hearing Impaired"
      end
    end

    def extract_downloads
      extract_field("tr:nth-child(4) td.newsDate") do |node|
        /(?<downloads>\d*) Downloads/.match(node.content)[:downloads]
      end
    end

    def extract_comment
      extract_field("tr:nth-child(2) td.newsDate") do |node|
        node.content.gsub(/<img[^>]+\>/i, "")
      end
    end
  end
end
