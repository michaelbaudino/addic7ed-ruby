module Addic7ed
  class NormalizeComment
    include Service

    attr_reader :comment

    def initialize(comment)
      @comment = comment || ""
    end

    def call
      comment.downcase
    end
  end
end
