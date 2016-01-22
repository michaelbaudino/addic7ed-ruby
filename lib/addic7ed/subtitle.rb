module Addic7ed
  class Subtitle

    attr_reader :version, :language, :status, :via, :downloads, :comment
    attr_accessor :url

    def initialize(options = {})
      @version   = normalize_version(options[:version])
      @language  = options[:language]
      @status    = options[:status]
      @url       = options[:url]
      @via       = options[:via]
      @hi        = options[:hi]
      @downloads = options[:downloads].to_i || 0
      @comment   = normalize_comment(options[:comment])
    end

    def to_s
      "#{url}\t->\t#{version} (#{language}, #{status}) [#{downloads} downloads]#{" (via #{via})" if via}"
    end

    def works_for?(version = '', no_hi = false)
      hi_works = !@hi || !no_hi
      is_completed? and is_compatible_with? version and hi_works
    end

    def can_replace?(other_subtitle)
      return false unless is_completed?
      return true if other_subtitle.nil?
      language == other_subtitle.language &&
      is_compatible_with?(other_subtitle.version) &&
      is_more_popular_than?(other_subtitle)
    end

    def is_featured?
      via == "http://addic7ed.com"
    end

    def is_completed?
      status == 'Completed'
    end

  protected

    def normalize_version(version)
      (version || "").
        gsub(/(^Version *|720p|1080p|hdtv|proper|rerip|x\.?264)/i, '').
        gsub(/^[- \.]*/, '').gsub(/[- \.]*$/, '').
        upcase
    end

    def normalize_comment(comment)
      (comment || "").downcase
    end

    def is_compatible_with?(other_version)
      generally_compatible_with?(other_version) || commented_as_compatible_with?(other_version)
    end

    def generally_compatible_with?(other_version)
      version == other_version || COMPATIBILITY_720P[version] == other_version || COMPATIBILITY_720P[other_version] == version
    end

    def commented_as_compatible_with?(other_version)
      res   = comment.include? other_version.downcase
      res ||= comment.include? COMPATIBILITY_720P[other_version].downcase if COMPATIBILITY_720P[other_version]
      res ||= comment.include? COMPATIBILITY_720P[version].downcase       if COMPATIBILITY_720P[version]
      !!res
    end

    def is_more_popular_than?(other_subtitle)
      return true  if other_subtitle.nil?
      return false if other_subtitle.is_featured?
      return downloads > other_subtitle.downloads
    end
  end
end
