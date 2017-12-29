# frozen_string_literal: true

module Addic7ed
  class ParseSubtitleNodeChildFields
    include Service

    attr_reader :language_node

    FIELDS = %i[language status url corrected hi downloads].freeze

    def initialize(language_node)
      @language_node = language_node
    end

    def call
      FIELDS.map do |field|
        { field => send(field) }
      end.reduce(:merge)
    end

    private

    def language
      @language ||= language_node.text.gsub(/\A\W*/, "").gsub(/[^\w\)]*\z/, "")
    end

    def status
      @status ||= language_node.css("~ td b").first.text.strip
    end

    def url
      @url ||= "http://www.addic7ed.com" + language_node.css("~ td a.buttonDownload").first[:href]
    end

    def corrected
      return @corrected if defined? @corrected
      @corrected = language_node.parent.css("~ tr td.newsDate img")[0][:title] == "Corrected"
    end

    def hi
      return @hi if defined? @hi
      @hi = language_node.parent.css("~ tr td.newsDate img")[1][:title] == "Hearing Impaired"
    end

    def downloads
      @downloads ||= begin
        text = language_node.parent.css("~ tr td.newsDate").text
        /(?<downloads>\d*) Downloads/.match(text)[:downloads]
      end
    end
  end
end
