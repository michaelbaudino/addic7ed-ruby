module Addic7ed
  # Represents a subtitle search for a +video_filename+ in a +language+ with
  # multiple search +criterias+.
  #
  # @attr video_filename [String] Video file name we're searching subtitles for.
  # @attr language [String] ISO code of language (_e.g._ "en", "fr", "es").
  # @attr criterias [Hash] List of search criterias as a {Hash}.

  class Search
    attr_reader :video_filename, :language,  :criterias

    # Creates a new instance of {Search}.
    #
    # Currently supported search criterias are:
    # * +no_hi+: do not include hearing impaired subtitles (defaults to +false+)
    #
    # @param video_filename [String] Path to the video file for which we search subtitles
    #   (either relative or absolute path)
    # @param language [String] ISO code of target subtitles language
    # @param criterias [Hash] List of search criterias the subtitles must match
    #   (will be merged with default criterias as described above)
    #
    # @example
    #   Addic7ed::Search.new("Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv", :fr)
    #   #=> #<Addic7ed::Search
    #   #       @criterias={:no_hi=>false},
    #   #       @language=:fr,
    #   #       @video_filename="Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv"
    #   #   >

    def initialize(video_filename, language, criterias = {})
      @video_filename = video_filename
      @language       = language
      @criterias      = default_criterias.merge(criterias)
    end

    # Returns the {VideoFile} object representing the video file we're searching subtitles for.
    #
    # @return [VideoFile] the {VideoFile} associated with this {Search}

    def video_file
      @video_file ||= VideoFile.new(video_filename)
    end

    # Returns the {Episode} object we're searching subtitles for.
    #
    # @return [Episode] the {Episode} associated with this {Search}

    def episode
      @episode ||= Episode.new(video_file.showname, video_file.season, video_file.episode)
    end

    # Returns the list of all available subtitles for this search,
    # regardless of completeness, compatibility or search +criterias+.
    #
    # @return [SubtitlesCollection] all subtitles for the searched episode

    def all_subtitles
      @all_subtitles ||= SubtitlesCollection.new(episode.subtitles(language))
    end

    # Returns the list of subtitles completed and compatible with the episode we're searching
    # subtitles for, regardless of search +criterias+.
    #
    # @return [SubtitlesCollection] subtitles completed and compatible with the searched episode

    def matching_subtitles
      @matching_subtitles ||= all_subtitles.completed.compatible_with(video_file.group)
    end

    # Returns the best subtitle for the episode we're searching subtitles for.
    #
    # The best subtitle means the more popular (_i.e._ most downloaded) subtitle among completed,
    # compatible subtitles for the episode we're searching subtitles for.
    #
    # @return [SubtitlesCollection] subtitles completed and compatible with the searched episode

    def best_subtitle
      @best_subtitle ||= matching_subtitles.most_popular
    end

  private

    def default_criterias
      {
        no_hi: false
      }
    end
  end
end
