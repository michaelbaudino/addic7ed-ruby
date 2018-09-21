# frozen_string_literal: true

require "oga"

module Addic7ed
  class ParseSubtitleNode
    include Service

    attr_reader :subtitle_node

    def initialize(subtitle_node)
      @subtitle_node = subtitle_node
    end

    def call
      children_fields.map do |child_fields|
        Addic7ed::Subtitle.new(root_fields.merge(child_fields))
      end
    end

    private

    def root_fields
      @root_fields ||= ParseSubtitleNodeRootFields.call(subtitle_node)
    end

    def children_fields
      @children_fields ||= subtitle_node.css(".language").map do |language_node|
        ParseSubtitleNodeChildFields.call(language_node)
      end
    end
  end
end
