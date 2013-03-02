module Addic7ed
  class Subtitle

    attr_reader :version, :language, :status, :downloads
    attr_accessor :url

    def initialize(version, language, status, url, downloads)
      @version   = version.upcase
      @language  = language
      @status    = status
      @url       = url
      @downloads = downloads.to_i
    end

    def to_s
      "#{url}\t->\t#{@version} (#{language}, #{status}) [#{@downloads} downloads]"
    end

  end
end