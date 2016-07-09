module Addic7ed
  class VideoFile
    TVSHOW_REGEX = /\A(?<showname>.*\w)[\[\. ]+S?(?<season>\d{1,2})[-\. ]?[EX]?(?<episode>\d{2})([-\. ]?[EX]?\d{2})*[\]\. ]+(?<tags>.*)-(?<group>\w*)\[?(?<distribution>\w*)\]?(\.\w{3})?\z/i # rubocop:disable Style/LineLength

    attr_reader :filename, :regexp_matches

    def initialize(filename)
      @filename = filename
      @regexp_matches = TVSHOW_REGEX.match(basename)
      raise InvalidFilename if regexp_matches.nil?
    end

    def showname
      @showname ||= regexp_matches[:showname]
    end

    def season
      @season ||= regexp_matches[:season].to_i
    end

    def episode
      @episode ||= regexp_matches[:episode].to_i
    end

    def tags
      @tags ||= regexp_matches[:tags].upcase.split(/[\. ]/)
    end

    def group
      @group ||= regexp_matches[:group].upcase
    end

    def distribution
      @distribution ||= regexp_matches[:distribution].upcase
    end

    def basename
      @basename ||= File.basename(filename)
    end

    def to_s
      filename
    end

    def inspect
      "Guesses for #{filename}:\n"      \
      "  show:         #{showname}\n"   \
      "  season:       #{season}\n"     \
      "  episode:      #{episode}\n"    \
      "  tags:         #{tags}\n"       \
      "  group:        #{group}\n"      \
      "  distribution: #{distribution}"
    end
  end
end
