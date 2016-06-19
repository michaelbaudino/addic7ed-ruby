module Addic7ed
  class URLEncodeShowName
    include Service

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    # This method is unfortunately over complex because we have to compare the given show name to
    # the actual Addic7ed shows list in order to find out how Addic7ed URL-encodes this show name
    # (this is due to the inconsistency of their URL-encoding policy)
    def call
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
      @humanized_name ||= filename.
                            gsub(/[_\.]+/, ' ').
                            gsub(/ (US|UK)( |$)/i, ' (\1)\2').
                            gsub(/ (\d{4})( |$)/i, ' (\1)\2')
    end

    def addic7ed_shows
      @addic7ed_shows ||= GetShowsList.call
    end
  end
end
