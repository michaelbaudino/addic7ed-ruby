module Addic7ed
  class ShowList
    attr_reader :raw_name

    def initialize(raw_name)
      @raw_name = raw_name
    end

    def self.find(raw_name)
      new(raw_name).find
    end

    def find
      matching_shows = human_list.select{ |i| [i, human_name].map{ |name| name.downcase.gsub("'", "") }.reduce(:==) }
      raise ShowNotFound if matching_shows.empty?
      matching_shows.first.gsub(' ', '_')
    end

    private

    def human_name
      @human_name ||= raw_name.
                        gsub(/[_\.]+/, ' ').
                        gsub(/ (US|UK)( |$)/i, ' (\1)\2').
                        gsub(/ (\d{4})( |$)/i, ' (\1)\2')
    end

    def human_list
      @@human_list ||= Nokogiri::HTML(addic7ed_homepage.body).css("select#qsShow option:not(:first-child)").map(&:text)
    end

    def addic7ed_homepage
      Net::HTTP.start("www.addic7ed.com", 80) do |http|
        request = Net::HTTP::Get.new("/")
        request["User-Agent"] = USER_AGENTS.sample
        http.request(request)
      end
    end
  end
end
