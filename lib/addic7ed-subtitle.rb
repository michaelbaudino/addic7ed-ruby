module Addic7ed
  class Subtitle

    attr_reader :title, :language, :status, :url

    def initialize(title, language, status, url)
      @title    = title
      @language = language
      @status   = status
      @url      = url
    end

    def to_s
      "#{url}\t->\t#{@title} (#{language}, #{status})"
    end

  end
end