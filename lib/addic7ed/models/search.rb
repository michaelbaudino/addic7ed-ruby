module Addic7ed
  class Search
    attr_reader :video_filename, :language,  :criterias

    def initialize(video_filename, language, criterias = {})
      @video_filename = video_filename
      @language       = language
      @criterias      = default_criterias.merge(criterias)
    end

    def video_file
      @video_file ||= VideoFile.new(video_filename)
    end

    def episode
      @episode ||= Episode.new(video_file.showname, video_file.season, video_file.episode)
    end

    def all_subtitles
      @all_subtitles ||= SubtitlesCollection.new(episode.subtitles(language))
    end

    def matching_subtitles
      @matching_subtitles ||= all_subtitles.completed.compatible_with(video_file.group)
    end

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
