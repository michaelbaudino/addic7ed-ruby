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
      if LANGUAGES[lang]
        url = "http://www.addic7ed.com/serie/#{@filename.showname.gsub(' ', '_')}/#{@filename.season}/#{@filename.episode}/#{LANGUAGES[lang][:id]}"
        if Net::HTTP.get_response(URI(url)).body != " "
          url
        else
          raise EpisodeNotFoundError
        end
      else
        raise LanguageNotSupportedError
      end
    end

    protected

    def find_show_id
      Nokogiri::HTML(open(SHOWS_URL)).css('option').each do |show_html|
        @show_id = show_html['value'] if show_html.content == @filename.showname
      end
      @show_id or raise ShowNotFoundError
    end

    def find_global_url
      response = Net::HTTP.get_response(URI("#{EPISODE_REDIRECT_URL}?ep=#{show_id}-#{@filename.season}x#{@filename.episode}"))
      if response['location'] and not response['location'] == '/index.php'
        @global_url = 'http://www.addic7ed.com/' + response['location']
      else
        raise EpisodeNotFoundError
      end
    end
  end
end
