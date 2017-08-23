# frozen_string_literal: true

module Addic7ed
  # Represents a collection of {Subtitle} objects.
  #
  # This collection is a custom {Enumerable} which provides
  # some methods to filter, order and choose the best subtitle.
  class SubtitlesCollection
    include Enumerable

    # @!visibility private
    def each(&block)
      @subtitles.each(&block)
    end

    # Creates a filterable, sortable collection of subtitles
    # @param subtitles [Enumerable] List of subtitles to initialize the collection with
    #
    # @return [SubtitleCollection] the initialized subtitles collection

    def initialize(subtitles = [])
      @subtitles = subtitles
    end

    # Returns only subtitles that are compatible with +group+.
    # @param group [String] Release group we want the returned subtitles to be compatible with
    #
    # @return [SubtitleCollection] Copy of collection with subtitles compatible with +group+ only
    #
    # @example
    #   fov        = Addic7ed::Subtitle.new(version: "FOV")
    #   lol        = Addic7ed::Subtitle.new(version: "LOL")
    #   dimension  = Addic7ed::Subtitle.new(version: "DIMENSION")
    #   collection = Addic7ed::SubtitlesCollection.new([fov, lol, dimension])
    #
    #   collection.compatible_with("DIMENSION")
    #   #=> [#<Addic7ed::Subtitle @version="LOL">, #<Addic7ed::Subtitle @version="DIMENSION">]

    def compatible_with(group)
      chainable(select { |subtitle| CheckCompatibility.call(subtitle, group) })
    end

    # Returns only completed subtitles.
    #
    # @return [SubtitleCollection] Copy of collection with completed subtitles only
    #
    # @example
    #   complete   = Addic7ed::Subtitle.new(status: "Completed")
    #   wip        = Addic7ed::Subtitle.new(status: "50%")
    #   collection = Addic7ed::SubtitlesCollection.new([complete, wip])
    #
    #   collection.completed
    #   #=> [#<Addic7ed::Subtitle @status="Completed">]

    def completed
      chainable(select(&:completed?))
    end

    # Returns the most downloaded subtitle.
    #
    # @return [Subtitle] Subtitle of the collection with the more downloads
    #
    # @example
    #   popular    = Addic7ed::Subtitle.new(downloads: 1000)
    #   unpopular  = Addic7ed::Subtitle.new(downloads: 3)
    #   collection = Addic7ed::SubtitlesCollection.new([popular, unpopular])
    #
    #   collection.most_popular
    #   #=> #<Addic7ed::Subtitle @downloads=1000>

    def most_popular
      sort_by(&:downloads).last
    end

    private

    def chainable(array)
      self.class.new(array)
    end
  end
end
