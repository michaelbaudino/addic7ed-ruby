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
      raise LanguageNotSupported unless LANGUAGES[lang]
      unless @best_subtitle and @best_subtitle[lang]
        @best_subtitle ||= {}
        subtitles(lang).each do |sub|
          if sub.status == 'Completed' and (sub.version == @filename.group or COMPATIBILITY_720P[sub.version] == @filename.group)
            @best_subtitle[lang] = sub unless @best_subtitle[lang] and @best_subtitle[lang].downloads > sub.downloads
          end
        end
        raise NoSubtitleFound unless @best_subtitle[lang]
      end
      return @best_subtitle[lang]
    end

    def download_best_subtitle!(lang = 'fr', redirect_limit = 8)
      raise WTFError.new('Too many HTTP redirects') if redirect_limit == 0
      begin
        uri = URI(best_subtitle(lang).url)
        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          # Addic7ed needs the Referer to be correct. User-agent is just here to fake a real browser request, because we never know...
          request['Referer'] = url(lang)
          request['User-Agent'] = USER_AGENTS.sample
          http.request(request)
        end
      rescue
        raise DownloadError
      end
      if response.kind_of?(Net::HTTPRedirection)
        # Addic7ed is serving redirection URL not-encoded.
        # Ruby does not support it yet (see http://bugs.ruby-lang.org/issues/7396)
         best_subtitle(lang).url = URI.escape(response['location'])
         raise DownloadLimitReached if /^\/downloadexceeded.php/.match best_subtitle(lang).url
         download_best_subtitle!(lang, redirect_limit - 1)
      else
        begin
          open "#{filename}".gsub(/\.\w{3}$/, '.srt'), 'w' do |f|
            f << response.body
          end
        rescue
          raise SubtitleCannotBeSaved
        end
      end
    end

    protected

    def parse_subtitle_node(sub_node, lang)
      begin
        version_node = sub_node.css('.NewsTitle').first
        version = version_node.content.gsub(/ \nVersion /, '').gsub(/,.*/, '')
        language_node = sub_node.css('.language').first
        language = language_node.content.gsub(/\A\W*/, '').gsub(/[^\w\)]*\z/, '')
        raise WTFError.new("We're asking for #{LANGUAGES[lang][:name].capitalize} subtitles and Addic7ed gives us #{language.capitalize} subtitles") if LANGUAGES[lang][:name].downcase != language.downcase
        status_node = sub_node.css('tr:nth-child(3) td:nth-child(4) b').first
        status = status_node.content.strip
        url_node = sub_node.css('a.buttonDownload').first
        url = 'http://www.addic7ed.com' + url_node['href']
        downloads_node = sub_node.css('tr:nth-child(4) td.newsDate').first
        downloads = /(?<downloads>\d*) Downloads/.match(downloads_node.content)[:downloads]
        Addic7ed::Subtitle.new(version, language, status, url, downloads)
      rescue
        raise ParsingError
      end
    end

  end
end
