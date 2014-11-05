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
      find_subtitles(lang) unless @subtitles and @subtitles[lang]
      return @subtitles[lang]
    end

    def best_subtitle(lang = 'fr')
      check_language_availability(lang)
      find_best_subtitle(lang) unless @best_subtitle and @best_subtitle[lang]
      return @best_subtitle[lang]
    end

    def download_best_subtitle!(lang, http_redirect_limit = 8)
      raise HTTPError.new('Too many HTTP redirects') unless http_redirect_limit > 0
      uri = URI(best_subtitle(lang).url)
      response = get_http_response(uri, url(lang))
      if response.kind_of?(Net::HTTPRedirection)
        follow_redirection(lang, response['location'], http_redirect_limit)
      else
        save_subtitle response
      end
    end

    protected

    def find_subtitles(lang)
      initialize_language(lang)
      parser = Addic7ed::Parser.new(self, lang)
      @subtitles[lang] = parser.extract_subtitles
    end

    def find_best_subtitle(lang)
      @best_subtitle ||= {}
      subtitles(lang).each do |sub|
        @best_subtitle[lang] = sub if sub.works_for? @filename.group and sub.can_replace? @best_subtitle[lang]
      end
      raise NoSubtitleFound unless @best_subtitle[lang]
    end

    def check_language_availability(lang)
      raise LanguageNotSupported unless LANGUAGES[lang]
    end

    def initialize_language(lang)
      @subtitles ||= {}
      @subtitles[lang] ||= []
    end

    def get_http_response(uri, referer)
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        # Addic7ed needs the Referer to be correct. User-agent is just here to fake a real browser request.
        request['Referer'] = referer
        request['User-Agent'] = USER_AGENTS.sample
        http.request(request)
      end
    rescue
      raise DownloadError
    end

    def follow_redirection(lang, new_uri, http_redirect_limit)
      # Addic7ed is serving redirection URL not-encoded, but Ruby does not support it (see http://bugs.ruby-lang.org/issues/7396)
      best_subtitle(lang).url = URI.escape(new_uri)
      raise DownloadLimitReached if /^\/downloadexceeded.php/.match best_subtitle(lang).url
      download_best_subtitle!(lang, http_redirect_limit - 1)
    end

    def save_subtitle(content)
      subname = content.header['content-disposition'][/"(.*)"/, 1].gsub(/\.\w.*Addic7ed.com/, '')
      Kernel.open @filename.dirname + "/" + subname, 'w' do |f|
        f << content.body
      end
      videoname = subname.gsub(/\.\w{3}$/, @filename.extname)
      File.rename(@filename.to_s, @filename.dirname + "/" +videoname)
    rescue
      raise SubtitleCannotBeSaved
    end

  end
end
