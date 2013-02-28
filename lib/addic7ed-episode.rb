require 'nokogiri'
require 'net/http'
require 'open-uri'

module Addic7ed
  class Episode

    attr_reader :filename

    def initialize(filename)
      @filename = Addic7ed::Filename.new(filename)
    end

    def show_id
      @show_id ||= find_show_id
    end

    def global_url
      @global_url ||= find_global_url
    end

    def localized_url(lang = 'fr')
      raise LanguageNotSupported unless LANGUAGES[lang]
      @localized_urls ||= {}
      @localized_urls[lang] ||= "http://www.addic7ed.com/serie/#{@filename.showname.gsub(' ', '_')}/#{@filename.season}/#{@filename.episode}/#{LANGUAGES[lang][:id]}"
    end

    def subtitles(lang = 'fr')
      raise LanguageNotSupported unless LANGUAGES[lang]
      unless @subtitles and @subtitles[lang]
        @subtitles ||= {}
        @subtitles[lang] ||= []
        response = Net::HTTP.get_response(URI(localized_url(lang)))
        raise EpisodeNotFound if response.body == " "
        doc = Nokogiri::HTML(response.body)
        raise NoSubtitleFound unless doc.css('select#filterlang ~ font[color="yellow"]').empty?
        sublist_node = doc.css('#container95m table.tabel95 table.tabel95')
        raise NoSubtitleFound if sublist_node.size == 0
        sublist_node.each do |sub_node|
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
            @subtitles[lang] << Addic7ed::Subtitle.new(title, language, status, url, downloads)
          rescue
            raise ParsingError
          end
        end
      end
      @subtitles[lang]
    end

    protected

    def find_show_id
      Nokogiri::HTML(open(SHOWS_URL)).css('option').each do |show_html|
        @show_id = show_html['value'] if show_html.content == @filename.showname
      end
      @show_id or raise ShowNotFound
    end

    def find_global_url
      response = Net::HTTP.get_response(URI("#{EPISODE_REDIRECT_URL}?ep=#{show_id}-#{@filename.season}x#{@filename.episode}"))
      if response['location'] and not response['location'] == '/index.php'
        @global_url = 'http://www.addic7ed.com/' + response['location']
      else
        raise EpisodeNotFound
      end
    end
  end
end
