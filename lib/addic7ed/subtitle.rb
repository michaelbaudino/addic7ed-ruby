module Addic7ed
  class Subtitle

    attr_reader :version, :language, :status, :via, :downloads
    attr_accessor :url

    def initialize(version, language, status, url, via, downloads)
      @version   = normalized_version(version)
      @language  = language
      @status    = status
      @url       = url
      @via       = via
      @downloads = downloads.to_i
    end

    def to_s
      "#{url}\t->\t#{@version} (#{language}, #{status}) [#{@downloads} downloads]#{" (via #{via})" if @via}"
    end

    private

    def normalized_version(version)
      version.
        gsub(/720p/i, '').
        gsub(/hdtv/i, '').
        gsub(/x\.?264/i, '').
        gsub(/^[- \.]*/, '').
        gsub(/[- \.]*$/, '').
        gsub(/^Version */i, '').
        upcase
    end

  end
end