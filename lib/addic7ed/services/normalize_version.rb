module Addic7ed
  class NormalizeVersion
    attr_reader :version

    def initialize(version)
      @version = version || ""
    end

    def self.call(version)
      new(version).call
    end

    def call
      version.
        gsub(/[[:space:]]/, "").
        upcase.
        gsub(/,[\d\. ]+MBS$/, '').
        gsub(/(^VERSION *|720P|1080P|HDTV|PROPER|RERIP|INTERNAL|X\.?264)/, '').
        gsub(/[- \.]/, '')
    end
  end

private
end
