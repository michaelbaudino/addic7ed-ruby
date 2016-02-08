module Addic7ed
  class ShowList
    attr_reader :raw_name

    def initialize(raw_name)
      @raw_name = raw_name
    end

    def self.url_segment_for(raw_name)
      new(raw_name).url_segment_for
    end

    def url_segment_for
      raise ShowNotFound if matching_shows.empty?
      matching_shows.first.gsub(' ', '_')
    end

    private

    def humanized_name
      @humanized_name ||= raw_name.
                            gsub(/[_\.]+/, ' ').
                            gsub(/ (US|UK)( |$)/i, ' (\1)\2').
                            gsub(/ (\d{4})( |$)/i, ' (\1)\2')
    end

    def matching_shows
      @matching_shows ||= addic7ed_shows.select do |addic7ed_show|
        [addic7ed_show, humanized_name].map{ |showname| showname.downcase.gsub("'", "") }.reduce(:==)
      end
    end

    def addic7ed_shows
      @@addic7ed_shows ||= Nokogiri::HTML(addic7ed_homepage.body).css("select#qsShow option:not(:first-child)").map(&:text)
    end

    def addic7ed_homepage
      Net::HTTP.start("www.addic7ed.com") do |http|
        request = Net::HTTP::Get.new("/")
        request["User-Agent"] = USER_AGENTS.sample
        http.request(request)
      end
    end
  end
end
