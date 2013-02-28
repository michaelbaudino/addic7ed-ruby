module Addic7ed
  class Subtitle

    attr_reader :title, :language, :status, :url, :downloads

    def initialize(title, language, status, url, downloads)
      @title     = title
      @language  = language
      @status    = status
      @url       = url
      @downloads = downloads
    end

    def to_s
      "#{url}\t->\t#{@title} (#{language}, #{status}) [#{@downloads} downloads]"
    end

  end
end