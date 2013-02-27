module Addic7ed
  class Subtitle

    attr_reader :episode

    def initialize(filename)
      @episode = Addic7ed::Episode.new(filename)
    end

    def show_id
      @show_id ||= find_show_id
    end

    def episode_url
      @episode_url ||= find_episode_url
    end

    protected

    def find_show_id
      Nokogiri::HTML(open(SHOWS_URL)).css('option').each do |show_html|
        @show_id = show_html['value'] if show_html.content == @episode.showname
      end
      @show_id or raise ShowNotFoundError
    end

    def find_episode_url
      response = Net::HTTP.get_response(URI("#{EPISODE_REDIRECT_URL}?ep=#{show_id}-#{@episode.season}x#{@episode.episode}"))
      if response['location'] and not response['location'] == '/index.php'
        @episode_url = 'http://www.addic7ed.com/' + response['location']
      else
        raise EpisodeNotFoundError
      end
    end
  end
end
