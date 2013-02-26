module Addic7ed
  SHOWS_URL = 'http://www.addic7ed.com/ajax_getShows.php'
  SEASONS_URL = 'http://www.addic7ed.com/ajax_getSeasons.php'
  EPISODES_URL = 'http://www.addic7ed.com/ajax_getEpisodes.php'

  @shows_ids = {}

  class Subtitle

    attr_reader :episode

    def initialize(filename)
      @episode = Addic7ed::Episode.new(filename)
      init_shows
    end

    def init_shows
      @shows_ids ||= {}
      Nokogiri::HTML(open(SHOWS_URL)).css('option').each do |show_html|
        @shows_ids[show_html.content] = show_html['value']
      end
    end

  end
end
