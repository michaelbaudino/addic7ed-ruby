# frozen_string_literal: true

module Addic7ed
  # Represents the video file you're looking a subtitle for.
  #
  # This class will extract from the video file name the show name, season, episode, group, etc.
  #
  # It expects the file to be named according to The Scene rules,
  # but actually supports a wide variety of common naming schemes.
  class VideoFile
    # @!visibility private
    TVSHOW_REGEX = /\A(?<showname>.*\w)[\[\. ]+S?(?<season>\d{1,2})[-\. ]?[EX]?(?<episode>\d{2})([-\. ]?[EX]?\d{2})*[\]\. ]+(?<tags>.*)-(?<group>\w*)\[?(?<distribution>\w*)\]?(\.\w{3})?\z/i # rubocop:disable Metrics/LineLength

    # @!visibility private
    attr_reader :filename, :regexp_matches

    # Returns a new instance of {VideoFile}.
    # It expects a video file name, either with or without path and
    # either absolute or relative.
    #
    # @param filename [String] File name of the video file on disk
    #   (either relative or absolute).
    #
    # @return [String] Distribution group name
    #
    # @example
    #   Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   Addic7ed::VideoFile.new("/home/mike/Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   Addic7ed::VideoFile.new("../Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")

    def initialize(filename)
      @filename = filename
      @regexp_matches = TVSHOW_REGEX.match(basename)
      raise InvalidFilename if regexp_matches.nil?
    end

    # Returns the TV show name extracted from the file name.
    #
    # @return [String] TV show name
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.showname #=> "Game.of.Thrones"

    def showname
      @showname ||= regexp_matches[:showname]
    end

    # Returns the TV show season number extracted from the file name.
    #
    # @return [Integer] TV show season number
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.season #=> 6

    def season
      @season ||= regexp_matches[:season].to_i
    end

    # Returns the TV show episode number extracted from the file name.
    #
    # @return [Integer] TV show episode number
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.episode #=> 9

    def episode
      @episode ||= regexp_matches[:episode].to_i
    end

    # Returns the upcased release tags extracted from the file name
    # (like +HDTV+, +720P+, +XviD+, +PROPER+, ...).
    #
    # @return [Array<String>] Release video, audio or packaging tags
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.tags #=> ["720P", "HDTV", "X264"]

    def tags
      @tags ||= regexp_matches[:tags].upcase.split(/[\. ]/)
    end

    # Returns the upcased release group extracted from the file name.
    #
    # @return [String] Release group name
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.group #=> "AVS"

    def group
      @group ||= regexp_matches[:group].upcase
    end

    # Returns the upcased distribution group extracted from the file name.
    #
    # @return [String] Distribution group name
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS[eztv].mkv")
    #   video_file.distribution #=> "EZTV"

    def distribution
      @distribution ||= regexp_matches[:distribution].upcase
    end

    # Returns the base file name (without path).
    #
    # @return [String] Base file name
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("../Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.basename #=> "Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv"

    def basename
      @basename ||= File.basename(filename)
    end

    # Returns the video file name as passed to {#initialize}.
    #
    # @return [String] File name
    #
    # @example
    #   video_file = Addic7ed::VideoFile.new("../Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv")
    #   video_file.to_s #=> "../Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv"

    def to_s
      filename
    end

    # Returns a multiline, human-readable breakdown of the file name
    # including all detected attributes (show name, season, episode, tags, ...).
    #
    # @return [String] a human-readable breakdown of the file name

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
