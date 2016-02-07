module Addic7ed
  class VideoFile

    TVSHOW_REGEX = /\A(?<showname>.*\w)[\[\. ]+S?(?<season>\d{1,2})[-\. ]?[EX]?(?<episode>\d{2})([-\. ]?[EX]?\d{2})*[\]\. ]+(?<tags>.*)-(?<group>\w*)\[?(?<distribution>\w*)\]?(\.\w{3})?\z/i

    attr_reader :filename, :showname, :season, :episode, :tags, :group, :distribution

    def initialize(filename)
      @filename = filename
      if match = TVSHOW_REGEX.match(basename)
        @showname     = match[:showname].gsub('.', ' ')
        @season       = match[:season].to_i
        @episode      = match[:episode].to_i
        @tags         = match[:tags].upcase.split(/[\. ]/)
        @group        = match[:group].upcase
        @distribution = match[:distribution].upcase
      else
        raise InvalidFilename
      end
    end

    def encoded_showname
      @encoded_showname ||= showname.
        gsub(/ /, '_').
        gsub(/_(US)$/i, '_(\1)').
        gsub(/_(US)_/i, '_(\1)_').
        gsub(/_UK$/i, '').
        gsub(/_UK_/i, '_').
        gsub(/_\d{4}$/, '').
        gsub(/_\d{4}_/, '_')
    end

    # Lazy getters

    def basename
      @basename ||= ::File.basename(@filename)
    end

    def to_s
      @filename
    end

    def inspect
"Guesses for #{@filename}:
  show:         #{@showname}
  season:       #{@season}
  episode:      #{@episode}
  tags:         #{@tags}
  group:        #{@group}
  distribution: #{@distribution}"
    end

  end
end
