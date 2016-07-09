module Addic7ed
  class Subtitle
    attr_reader :version, :language, :status, :via, :downloads, :comment
    attr_accessor :url

    def initialize(options = {})
      @version   = NormalizeVersion.call(options[:version])
      @language  = options[:language]
      @status    = options[:status]
      @url       = options[:url]
      @via       = options[:via]
      @hi        = options[:hi]
      @downloads = options[:downloads].to_i || 0
      @comment   = NormalizeComment.call(options[:comment])
    end

    def to_s
      str = "#{url}\t->\t#{version} (#{language}, #{status}) [#{downloads} downloads]"
      str += " (via #{via})" if via
      str
    end

    def works_for?(version = "", no_hi = false)
      hi_works = !@hi || !no_hi
      completed? && compatible_with?(version) && hi_works
    end

    def can_replace?(other_subtitle)
      return false unless completed?
      return true if other_subtitle.nil?
      language == other_subtitle.language &&
        compatible_with?(other_subtitle.version) &&
        more_popular_than?(other_subtitle)
    end

    def featured?
      via == "http://addic7ed.com"
    end

    def completed?
      status == "Completed"
    end

  protected

    def compatible_with?(other_version)
      defined_as_compatible_with(other_version) ||
        generally_compatible_with?(other_version) ||
        commented_as_compatible_with?(other_version)
    end

    def defined_as_compatible_with(other_version)
      version.split(",").include? other_version
    end

    def generally_compatible_with?(other_version)
      COMPATIBILITY_720P[version] == other_version || COMPATIBILITY_720P[other_version] == version
    end

    def commented_as_compatible_with?(other_version)
      return false if /(won't|doesn't|not) +work/i =~ comment
      return false if /resync +(from|of)/i =~ comment
      known_compatible_versions(other_version)
        .push(other_version)
        .map(&:downcase)
        .map { |compatible_version| comment.include? compatible_version }
        .reduce(:|)
    end

    def known_compatible_versions(other_version)
      [COMPATIBILITY_720P[other_version], COMPATIBILITY_720P[version]].compact
    end

    def more_popular_than?(other_subtitle)
      return true  if other_subtitle.nil?
      return false if other_subtitle.featured?
      downloads > other_subtitle.downloads
    end
  end
end
