module Addic7ed
  class Addic7edCommentNormalizer
    attr_reader :comment

    def initialize(comment)
      @comment = comment || ""
    end

    def self.call(comment)
      new(comment).call
    end

    def call
      comment.downcase
    end
  end

private
end
