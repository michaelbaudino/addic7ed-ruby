# frozen_string_literal: true

module Addic7ed
  # Represents a subtitle on Addic7ed.
  #
  # This model contains as much information as possible for a subtitle
  # as parsed on Addic7ed website.
  #
  # @attr version [String] Main compatible release group(s)
  #   (evenually as a comma-separated list).
  # @attr language [String] Language the subtitle is written in
  #   (_e.g._: "French", "English").
  # @attr status [String] Translation/synchronization advancement status
  #   (_e.g._: "60%"" or "Completed").
  # @attr source [String] URL of website the subtitle was first published on.
  # @attr downloads [Numeric] Number of times this subtitle has been downloaded.
  # @attr comment [String] Comment manually added by the subtitle author/publisher
  #   (usually related to extra-compatibilities or resync source).
  # @attr corrected [Boolean] Indicates if the subtitle has been corrected.
  # @attr hi [Boolean] Indicates if the subtitle embeds hearing-impaired sequences.
  # @attr url [String] Download URL of actual subtitle file (warning: Addic7ed servers
  #   won't serve a subtite file without a proper +Referer+ HTTP header which can be
  #   retrieved from +episode.page_url+).

  class Subtitle
    attr_reader :version, :language, :status, :source, :downloads, :comment, :corrected, :hi
    attr_accessor :url

    # Creates a new instance of {Subtitle} created using +options+,
    # usually from data parsed from an Addic7ed page.
    #
    # The +options+ hash can have the following keys as symbols:
    # * +version+: main compatible release group(s) as parsed on the Addic7ed website
    # * +language+: language full name
    # * +status+: full-text advancement status
    # * +source+: URL of website the subtitle was originally published on
    # * +downloads+: number of times the subtitle has been downloaded
    # * +comment+: manually added comment from the author or publisher
    # * +corrected+: indicates if subtitle has been corrected
    # * +hi+: indicates if subtitle embeds hearing-impaired sequences
    # * +url+: download URL for the subtitle file
    #
    # @param options [Hash] subtitle information as a {Hash}
    #
    # @example
    #   Addic7ed::Subtitle.new(
    #     version:   "Version KILLERS, 720p AVS, 0.00 MBs",
    #     language:  "French",
    #     status:    "Completed",
    #     source:    "http://sous-titres.eu",
    #     downloads: 10335,
    #     comment:   "works with 1080p.BATV",
    #     corrected: true,
    #     hi:        false,
    #     url:       "http://www.addic7ed.com/original/113643/4"
    #   )
    #   #=> #<Addic7ed::Subtitle
    #   #       @version="KILLERS,AVS",
    #   #       @language="French",
    #   #       @status="Completed",
    #   #       @url="http://www.addic7ed.com/original/113643/4",
    #   #       @source="http://sous-titres.eu",
    #   #       @corrected=true,
    #   #       @hi=false,
    #   #       @downloads=10335,
    #   #       @comment="works with 1080p.batv"
    #   #   >

    def initialize(options = {})
      %i[language status url source corrected hi].each do |opt|
        instance_variable_set(:"@#{opt}", options[opt])
      end
      @downloads = options[:downloads].to_i || 0
      @version   = NormalizeVersion.call(options[:version])
      @comment   = NormalizeComment.call(options[:comment])
    end

    # Completeness status of the {Subtitle}.
    #
    # @return [Boolean] Returns +true+ if {Subtitle} is complete,
    #   +false+ otherwise (partially complete)
    #
    # @example
    #   Addic7ed::Subtitle.new(status: "50%").completed?       #=> false
    #   Addic7ed::Subtitle.new(status: "Completed").completed? #=> true

    def completed?
      status == "Completed"
    end
  end
end
