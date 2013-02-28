module Addic7ed
  class Filename

    TVSHOW_REGEX = /\A(?<showname>.*\w)[\[\. ]+S?(?<season>\d{1,2})[-\. ]?[EX]?(?<episode>\d{2})[\]\. ]+(?<tags>.*)-(?<group>\w*)(\.\w{3})?\z/i

    attr_reader :filename, :showname, :season, :episode, :tags, :group

    def initialize(filename)
      @filename = filename
      match = TVSHOW_REGEX.match basename
      if match
        @showname = match[:showname].gsub('.', ' ')
        @season   = match[:season].to_i
        @episode  = match[:episode].to_i
        @tags     = match[:tags].split(/[\. ]/)
        @group    = match[:group]
      else
        raise InvalidFilename
      end
    end

    # Lazy getters

    def basename
      @basename ||= File.basename(@filename)
    end

    def dirname
      @dirname ||= File.dirname(@filename)
    end

    def extname
      @extname ||= File.extname(@filename)
    end

    def to_s
"##### Guesses for #{@filename}
# Show:    #{@showname}
# Season:  #{@season}
# Episode: #{@episode}
# Tags:    #{@tags}
# Group:   #{@group}"
    end

  end
end
