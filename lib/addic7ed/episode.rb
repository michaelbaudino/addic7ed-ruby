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
      @localized_urls[lang] ||= "http://www.addic7ed.com/serie/#{ShowList.url_segment_for(video_file.showname)}/#{video_file.season}/#{video_file.episode}/#{LANGUAGES[lang][:id]}"
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

    def download_best_subtitle!(lang, no_hi = false)
      subtitle_url      = best_subtitle(lang, no_hi).url
      subtitle_filename = video_file.basename.gsub(/\.\w{3}$/, untagged ? ".srt" : ".#{lang}.srt")
      referer           = url(lang)
      SubtitleDownloader.call(subtitle_url, subtitle_filename, referer)
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
  end
end
