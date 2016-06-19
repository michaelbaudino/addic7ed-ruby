require 'net/http'
require 'open-uri'

module Addic7ed
  class Episode

    attr_reader :video_file, :untagged

    def initialize(filename, untagged = false)
      @video_file    = Addic7ed::VideoFile.new(filename)
      @untagged      = untagged
      @subtitles     = languages_hash { |code, _| {code => nil} }
      @best_subtitle = languages_hash { |code, _| {code => nil} }
    end

    def subtitles(lang = "en")
      @subtitles[lang] ||= Addic7ed::ParsePage.call(localized_urls[lang])
    end

    def best_subtitle(lang = "en", no_hi = false)
      @best_subtitle[lang] ||= find_best_subtitle(lang, no_hi)
    end

    def download_best_subtitle!(lang, no_hi = false)
      subtitle_url      = best_subtitle(lang, no_hi).url
      subtitle_filename = video_file.basename.gsub(/\.\w{3}$/, untagged ? ".srt" : ".#{lang}.srt")
      referer           = localized_urls[lang]
      DownloadSubtitle.call(subtitle_url, subtitle_filename, referer)
    end

  protected

    def localized_urls
      @localized_urls ||= languages_hash { |code, lang| {code => localized_url(lang[:id])} }
    end

    def find_best_subtitle(lang, no_hi = false)
      subtitles(lang).each do |sub|
        @best_subtitle[lang] = sub if sub.works_for?(video_file.group, no_hi) && sub.can_replace?(@best_subtitle[lang])
      end
      raise NoSubtitleFound unless @best_subtitle[lang]
    end

    def url_segment
      @url_segment ||= ShowList.url_segment_for(video_file.showname)
    end

    def localized_url(lang)
      "http://www.addic7ed.com/serie/#{url_segment}/#{video_file.season}/#{video_file.episode}/#{lang}"
    end

    def languages_hash(&block)
      Hash.new { raise LanguageNotSupported }.merge(LANGUAGES.map(&block).reduce(&:merge))
    end
  end
end
