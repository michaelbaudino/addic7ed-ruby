module Addic7ed
  class NormalizeVersion
    include Service

    attr_reader :version

    def initialize(version)
      @version = version || ""
    end

    def call
      version
        .gsub(/[[:space:]]/, "")
        .upcase
        .gsub(/,[\d\. ]+MBS$/, "")
        .gsub(/(^VERSION *|720P|1080P|HDTV|PROPER|RERIP|INTERNAL|X\.?264)/, "")
        .gsub(/[- \.\,]/, " ")
        .strip
        .gsub(/ +/, ",")
    end
  end
end
