require 'net/http'
require 'open-uri'

module Addic7ed
  class Episode

    attr_reader :filename

    def initialize(filename)
      @filename = Addic7ed::Filename.new(filename)
    end

    def url(lang = 'fr')
      check_language_availability(lang)
      @localized_urls ||= {}
      @localized_urls[lang] ||= "http://www.addic7ed.com/serie/#{@filename.encoded_showname}/#{@filename.season}/#{@filename.episode}/#{LANGUAGES[lang][:id]}"
    end

    def subtitles(lang = 'fr')
      check_language_availability(lang)
      unless @subtitles and @subtitles[lang]
        initialize_language(lang)
        parser = Addic7ed::Parser.new(self, lang)
        @subtitles[lang] = parser.extract_subtitles
      end
      @subtitles[lang]
    end

    def best_subtitle(lang = 'fr')
      check_language_availability lang
      unless @best_subtitle and @best_subtitle[lang]
        @best_subtitle ||= {}
        subtitles(lang).each do |sub|
          if sub.status == 'Completed' and (sub.version == @filename.group or COMPATIBILITY_720P[sub.version] == @filename.group or COMPATIBILITY_720P[@filename.group] == sub.version)
            @best_subtitle[lang] = sub unless @best_subtitle[lang] and (@best_subtitle[lang].downloads > sub.downloads or @best_subtitle[lang].via == 'http://addic7ed.com')
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

    def check_language_availability(lang)
      raise LanguageNotSupported unless LANGUAGES[lang]
    end

    def initialize_language(lang)
      @subtitles ||= {}
      @subtitles[lang] ||= []
    end

  end
end
