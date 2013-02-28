require 'nokogiri'
require 'net/http'
require 'open-uri'

module Addic7ed
  class Episode

    attr_reader :filename

    def initialize(filename)
      @filename = Addic7ed::Filename.new(filename)
    end

    def url(lang = 'fr')
      raise LanguageNotSupported unless LANGUAGES[lang]
      @localized_urls ||= {}
      @localized_urls[lang] ||= "http://www.addic7ed.com/serie/#{@filename.showname.gsub(' ', '_')}/#{@filename.season}/#{@filename.episode}/#{LANGUAGES[lang][:id]}"
    end

    def subtitles(lang = 'fr')
      raise LanguageNotSupported unless LANGUAGES[lang]
      unless @subtitles and @subtitles[lang]
        @subtitles ||= {}
        @subtitles[lang] ||= []
        response = Net::HTTP.get_response(URI(url(lang)))
        raise EpisodeNotFound if response.body == " "
        doc = Nokogiri::HTML(response.body)
        raise NoSubtitleFound unless doc.css('select#filterlang ~ font[color="yellow"]').empty?
        sublist_node = doc.css('#container95m table.tabel95 table.tabel95')
        raise NoSubtitleFound if sublist_node.size == 0
        sublist_node.each do |sub_node|
          @subtitles[lang] << parse_subtitle_node(sub_node, lang)
        end
      end
      @subtitles[lang]
    end

    def best_subtitle(lang = 'fr')
      # TODO
    end

    protected

    def parse_subtitle_node(sub_node, lang)
      begin
        title_node = sub_node.css('.NewsTitle').first
        title = title_node.content.gsub(/ \nVersion /, '').gsub(/,.*/, '')
        language_node = sub_node.css('.language').first
        language = language_node.content.gsub(/\A\W*/, '').gsub(/[^\w\)]*\z/, '')
        raise WTFError.new("We're asking for #{LANGUAGES[lang][:name].capitalize} subtitles and Addic7ed gives us #{language.capitalize} subtitles") if LANGUAGES[lang][:name].downcase != language.downcase
        status_node = sub_node.css('tr:nth-child(3) td:nth-child(4) b').first
        status = status_node.content.strip
        url_node = sub_node.css('a.buttonDownload').first
        url = 'http://www.addic7ed.com' + url_node['href']
        downloads_node = sub_node.css('tr:nth-child(4) td.newsDate').first
        downloads = /(?<downloads>\d*) Downloads/.match(downloads_node.content)[:downloads]
        Addic7ed::Subtitle.new(title, language, status, url, downloads)
      rescue
        raise ParsingError
      end
    end

  end
end
