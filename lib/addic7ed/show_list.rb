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
      shows_matching = shows_matching_exactly
      shows_matching = shows_matching_without_year if shows_matching.empty?
      raise ShowNotFound if shows_matching.empty?
      shows_matching.last.gsub(' ', '_')
    end

    private

    def shows_matching_exactly
      @shows_matching_exactly ||= addic7ed_shows.select{ |addic7ed_show| is_matching? addic7ed_show }
    end

    def shows_matching_without_year
      @shows_matching_without_year ||= addic7ed_shows.select{ |addic7ed_show| is_matching? addic7ed_show, :comparer_without_year }
    end

    def default_comparer(showname)
      showname.downcase.gsub("'", "").gsub(".", " ").strip
    end

    def comparer_without_year(showname)
      default_comparer(showname).gsub(/ \(\d{4}\)( |$)/, '\1')
    end

    def is_matching?(addic7ed_show, comparer = :default_comparer)
      [humanized_name, addic7ed_show].map(&method(comparer)).reduce(:==)
    end

    def humanized_name
      @humanized_name ||= raw_name.
                            gsub(/[_\.]+/, ' ').
                            gsub(/ (US|UK)( |$)/i, ' (\1)\2').
                            gsub(/ (\d{4})( |$)/i, ' (\1)\2')
    end

    def addic7ed_shows
      @@addic7ed_shows ||= Oga.parse_html(addic7ed_homepage.body).css("select#qsShow option:not(:first-child)").map(&:text)
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
