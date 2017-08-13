# frozen_string_literal: true

module Addic7ed
  class NormalizeComment
    include Service

    attr_reader :comment

    def initialize(comment)
      @comment = comment || ""
    end

    def call
      comment.downcase.strip
    end
  end
end
