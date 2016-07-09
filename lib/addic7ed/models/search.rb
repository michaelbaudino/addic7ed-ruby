module Addic7ed
  class Search
    attr_reader :video_filename, :language,  :options

    def initialize(video_filename, language, options = {})
      @video_filename = video_filename
      @language       = language
      @options        = default_options.merge(options)
    end

    def video_file
      @video_file ||= VideoFile.new(video_filename)
    end

    def episode
      @episode ||= Episode.new(video_file.showname, video_file.season, video_file.episode)
    end

    def best_subtitle
      episode.subtitles(language).each do |subtitle|
        @best_subtitle = subtitle if subtitle.works_for?(video_file.group, options[:no_hi]) && subtitle.can_replace?(@best_subtitle)
      end
      @best_subtitle || raise(NoSubtitleFound)
    end

  private

    def default_options
      {no_hi: false}
    end
  end
end
