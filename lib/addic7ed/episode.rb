require 'net/http'
require 'open-uri'

module Addic7ed
  class Episode

    attr_reader :video_file, :untagged

    def initialize(filename, untagged = false)
      @video_file  = Addic7ed::VideoFile.new(filename)
      @untagged = untagged
    end

    def url(lang = 'fr')
      check_language_availability(lang)
      @localized_urls ||= {}
      @localized_urls[lang] ||= "http://www.addic7ed.com/serie/#{video_file.encoded_showname}/#{video_file.season}/#{video_file.episode}/#{LANGUAGES[lang][:id]}"
    end

    def subtitles(lang = 'fr')
      check_language_availability(lang)
      find_subtitles(lang) unless @subtitles and @subtitles[lang]
      return @subtitles[lang]
    end

    def best_subtitle(lang = 'fr', no_hi = false)
      check_language_availability(lang)
      find_best_subtitle(lang, no_hi) unless @best_subtitle and @best_subtitle[lang]
      return @best_subtitle[lang]
    end

    def download_best_subtitle!(lang, no_hi = false, http_redirect_limit = 8)
      raise HTTPError.new('Too many HTTP redirects') unless http_redirect_limit > 0
      uri = URI(best_subtitle(lang, no_hi).url)
      response = get_http_response(uri, url(lang))
      if response.kind_of?(Net::HTTPRedirection)
        follow_redirection(lang, no_hi, response['location'], http_redirect_limit)
      else
        save_subtitle(response.body, lang)
      end
    end

  protected

    def find_subtitles(lang)
      initialize_language(lang)
      parser = Addic7ed::Parser.new(self, lang)
      @subtitles[lang] = parser.extract_subtitles
    end

    def find_best_subtitle(lang, no_hi = false)
      @best_subtitle ||= {}
      subtitles(lang).each do |sub|
        @best_subtitle[lang] = sub if sub.works_for?(video_file.group, no_hi) and sub.can_replace? @best_subtitle[lang]
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

    def follow_redirection(lang, no_hi, new_uri, http_redirect_limit)
      # Addic7ed is serving redirection URL not-encoded, but Ruby does not support it (see http://bugs.ruby-lang.org/issues/7396)
      best_subtitle(lang).url = URI.escape(new_uri)
      raise DownloadLimitReached if /^\/downloadexceeded.php/.match best_subtitle(lang).url
      download_best_subtitle!(lang, no_hi, http_redirect_limit - 1)
    end

    def save_subtitle(content, lang)
      Kernel.open "#{video_file}".gsub(/\.\w{3}$/, untagged ? ".srt" : ".#{lang}.srt"), 'w' do |f|
        f << content
      end
    rescue
      raise SubtitleCannotBeSaved
    end
  end
end
