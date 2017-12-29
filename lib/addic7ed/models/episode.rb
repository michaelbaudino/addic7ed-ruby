# frozen_string_literal: true

require "net/http"
require "open-uri"

module Addic7ed
  # Represents a TV show episode.
  #
  # @attr show [String] TV show name.
  # @attr season [Numeric] Season number.
  # @attr number [Numeric] Episode number in the season.

  class Episode
    attr_reader :show, :season, :number

    # Creates a new instance of {Episode}.
    #
    # @param show [String] TV show name
    #   (_e.g._ both +"Game.of.Thrones"+ and +"Game of Thrones"+ are valid)
    # @param season [Numeric] Season number
    # @param number [Numeric] Episode number in the season
    #
    # @example
    #   Addic7ed::Episode.new(show: "Game of Thrones", season: 6, number: 9)
    #   #=> #<Addic7ed::Episode
    #   #       @number=9,
    #   #       @season=6,
    #   #       @show="Game.of.Thrones"
    #   #    >

    def initialize(show:, season:, number:)
      @show   = show
      @season = season
      @number = number
    end

    # Returns the URL of the Addic7ed webpage listing subtitles for this {Episode}.
    # If +language+ is given, it returns the URL of the page with subtitles for this language only.
    # (_warning:_ despite requesting a language, Addic7ed may display subtitles in all languages
    # if the requested language has no subtitle)
    #
    # @param language [String] Language code we want the webpage to list subtitles in.
    #
    # @return [String] Fully qualified URL of the webpage on Addic7ed.
    #
    # @example
    #   Addic7ed::Episode.new("Game of Thrones", 6, 9).page_url
    #   #=> "http://www.addic7ed.com/serie/Game_of_Thrones/6/9/0"
    #
    #   Addic7ed::Episode.new("Game of Thrones", 6, 9).page_url(:fr)
    #   #=> "http://www.addic7ed.com/serie/Game_of_Thrones/6/9/8"

    def page_url(language = nil)
      return localized_url(0) if language.nil?
      localized_urls[language]
    end

    # Returns all available subtitles for this episode.
    #
    # @return [SubtitlesCollection] the collection of subtitles.
    #
    # @example
    #   Addic7ed::Episode.new("Game of Thrones", 6, 9)
    #   #=> #<Addic7ed::SubtitlesCollection
    #   #     @subtitles=[
    #   #       #<Addic7ed::Subtitle ... >,
    #   #       #<Addic7ed::Subtitle ... >,
    #   #       #<Addic7ed::Subtitle ... >
    #   #     ]

    def subtitles
      @subtitles ||= SubtitlesCollection.new(
        Addic7ed::ParsePage.call(page_url)
      )
    end

    private

    def localized_urls
      @localized_urls ||= languages_hash { |code, lang| { code => localized_url(lang[:id]) } }
    end

    def url_encoded_showname
      @url_encoded_showname ||= URLEncodeShowName.call(show)
    end

    def localized_url(lang_id)
      "http://www.addic7ed.com/serie/#{url_encoded_showname}/#{season}/#{number}/#{lang_id}"
    end

    def languages_hash(&block)
      Hash.new { raise LanguageNotSupported }.merge(LANGUAGES.map(&block).reduce(&:merge))
    end
  end
end
