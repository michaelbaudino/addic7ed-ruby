require 'net/http'
require 'open-uri'

module Addic7ed
  class Episode

    attr_reader :showname, :season, :episode

    def initialize(showname, season, episode)
      @showname  = showname
      @season    = season
      @episode   = episode
      @subtitles = languages_hash { |code, _| {code => nil} }
    end

    def subtitles(lang)
      @subtitles[lang] ||= Addic7ed::ParsePage.call(page_url(lang))
    end

    def page_url(lang)
      localized_urls[lang]
    end

  protected

    def localized_urls
      @localized_urls ||= languages_hash { |code, lang| {code => localized_url(lang[:id])} }
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
