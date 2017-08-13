# frozen_string_literal: true

require "net/http"
require "open-uri"

module Addic7ed
  # Represents a TV show episode.
  #
  # @attr showname [String] TV show name.
  # @attr season [Numeric] Season number.
  # @attr episode [Numeric] Episode number in the season.

  class Episode
    attr_reader :showname, :season, :episode

    # Creates a new instance of {Episode}.
    #
    # @param showname [String] TV show name, as extracted from the video file name
    #   (_e.g._ both +"Game.of.Thrones"+ and +"Game of Thrones"+ are valid)
    # @param season [Numeric] Season number
    # @param episode [Numeric] Episode number in the season
    #
    # @example
    #   Addic7ed::Episode.new("Game of Thrones", 6, 9)
    #   #=> #<Addic7ed::Episode
    #   #       @episode=9,
    #   #       @season=6,
    #   #       @showname="Game.of.Thrones",
    #   #       @subtitles={:fr=>nil, :ar=>nil, :az=>nil, ..., :th=>nil, :tr=>nil, :vi=>nil}
    #   #    >

    def initialize(showname, season, episode)
      @showname  = showname
      @season    = season
      @episode   = episode
      @subtitles = languages_hash { |code, _| { code => nil } }
    end

    # Returns a list of all available {Subtitle}s for this {Episode} in the given +language+.
    #
    # @param language [String] Language code we want returned {Subtitle}s to be in.
    #
    # @return [Array<Subtitle>] List of {Subtitle}s available on Addic7ed for the given +language+.
    #
    # @example
    #   Addic7ed::Episode.new("Game.of.Thrones", 3, 9).subtitles(:fr)
    #   #=> [
    #   #      #<Addic7ed::Subtitle
    #   #          @comment="works with ctrlhd",
    #   #          @downloads=28130,
    #   #          @hi=false,
    #   #          @language="French",
    #   #          @source="http://addic7ed.com",
    #   #          @status="Completed",
    #   #          @url="http://www.addic7ed.com/updated/8/76081/0",
    #   #          @version="EVOLVE">,
    #   #      #<Addic7ed::Subtitle
    #   #          @comment="la fabrique",
    #   #          @downloads=1515,
    #   #          @hi=false,
    #   #          @language="French",
    #   #          @source="http://sous-titres.eu",
    #   #          @status="Completed",
    #   #          @url="http://www.addic7ed.com/original/76081/11",
    #   #          @version="EVOLVE">,
    #   #      #<Addic7ed::Subtitle
    #   #          @comment="la fabrique",
    #   #          @downloads=917,
    #   #          @hi=false,
    #   #          @language="French",
    #   #          @source="http://sous-titres.eu",
    #   #          @status="Completed",
    #   #          @url="http://www.addic7ed.com/original/76081/12",
    #   #          @version="WEB,DL,NTB,&,YFN">
    #   #     ]

    def subtitles(language)
      @subtitles[language] ||= Addic7ed::ParsePage.call(page_url(language))
    end

    # Returns the URL of the Addic7ed webpage listing subtitles for this {Episode}
    # in the given +language+.
    #
    # @param language [String] Language code we want the webpage to list subtitles in.
    #
    # @return [String] Fully qualified URL of the webpage on Addic7ed.
    #
    # @example
    #   Addic7ed::Episode.new("Game of Thrones", 6, 9).page_url
    #   #=> "http://www.addic7ed.com/serie/Game_of_Thrones/6/9/8"

    def page_url(language)
      localized_urls[language]
    end

    private

    def localized_urls
      @localized_urls ||= languages_hash { |code, lang| { code => localized_url(lang[:id]) } }
    end

    def url_encoded_showname
      @url_encoded_showname ||= URLEncodeShowName.call(showname)
    end

    def localized_url(lang)
      "http://www.addic7ed.com/serie/#{url_encoded_showname}/#{season}/#{episode}/#{lang}"
    end

    def languages_hash(&block)
      Hash.new { raise LanguageNotSupported }.merge(LANGUAGES.map(&block).reduce(&:merge))
    end
  end
end
