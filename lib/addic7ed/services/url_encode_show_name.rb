module Addic7ed
  class URLEncodeShowName
    include Service

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    # This service is unfortunately over complex because we have to compare the given show name to
    # the actual Addic7ed shows list in order to find out how Addic7ed URL-encodes this show name
    # (this is due to the inconsistency of their URL-encoding policy)
    def call
      matching_shows = matching_shows(ignore_year: false)
      matching_shows = matching_shows(ignore_year: true) if matching_shows.empty?
      raise ShowNotFound if matching_shows.empty?
      matching_shows.last.tr(" ", "_")
    end

  private

    def matching_shows(opts)
      addic7ed_shows.select { |show_name| matching?(show_name, opts) }
    end

    def normalize(show_name, opts)
      show_name
        .downcase
        .delete("'")
        .gsub(/[_\.]+/, " ")
        .gsub(/ (US|UK)( |$)/i, " (\\1)\\2")
        .gsub(/ (\d{4})( |$)/i, " (\\1)\\2")
        .strip
        .tap { |showname| showname.gsub!(/ \(\d{4}\)( |$)/, '\1') if opts[:ignore_year] }
    end

    def matching?(addic7ed_show, opts)
      normalize(addic7ed_show, opts) == normalize(filename, opts)
    end

    def addic7ed_shows
      @addic7ed_shows ||= GetShowsList.call
    end
  end
end
