# frozen_string_literal: true

module Addic7ed
  class ParseSubtitleNodeRootFields
    include Service

    attr_reader :subtitle_node

    FIELDS = %i[version source comment].freeze

    def initialize(subtitle_node)
      @subtitle_node = subtitle_node
    end

    def call
      FIELDS.map do |field|
        { field => send(field) }
      end.reduce(:merge)
    end

    private

    def version
      return @version if defined? @version
      @version = subtitle_node.css(".NewsTitle").first.text
    end

    def source
      return @source if defined? @source
      @source = subtitle_node.css("tr:nth-child(3) td:first-child a").first.tap do |node|
        break node[:href] if node
      end
    end

    def comment
      return @comment if defined? @comment
      @comment = subtitle_node.css("tr:nth-child(2) td.newsDate").first.tap do |node|
        break node.text.strip if node
      end
    end
  end
end
