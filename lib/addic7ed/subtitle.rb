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

    def works_for?(version = '')
      is_completed? and is_compatible_with? version
    end

    def can_replace?(other_sub)
      return false unless is_completed?
      return true if other_sub.nil?
      language == other_sub.language and
      is_compatible_with? other_sub.version and
      is_more_popular_than? other_sub
    end

    protected

    def normalized_version(version)
      version.
        gsub(/^Version */i, '').
        gsub(/720p/i, '').
        gsub(/hdtv/i, '').
        gsub(/proper/i, '').
        gsub(/x\.?264/i, '').
        gsub(/^[- \.]*/, '').
        gsub(/[- \.]*$/, '').
        upcase
    end

    def is_completed?
      status == 'Completed'
    end

    def is_compatible_with?(other_version)
      version == other_version or
      COMPATIBILITY_720P[version] == other_version or
      COMPATIBILITY_720P[other_version] == version
    end

    def is_more_popular_than?(other_sub)
      return true   if other_sub.nil?
      return false  if other_sub.via == 'http://addic7ed.com'
      return downloads > other_sub.downloads
    end

  end
end
