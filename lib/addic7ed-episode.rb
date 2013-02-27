module Addic7ed
  class Episode

    attr_reader :filename

    def initialize(filename)
      @filename = Addic7ed::Filename.new(filename)
    end

    def show_id
      @show_id ||= find_show_id
    end

    def url
      @url ||= find_url
    end

    protected

    def find_show_id
      Nokogiri::HTML(open(SHOWS_URL)).css('option').each do |show_html|
        @show_id = show_html['value'] if show_html.content == @filename.showname
      end
      @show_id or raise ShowNotFoundError
    end

    def find_url
      response = Net::HTTP.get_response(URI("#{EPISODE_REDIRECT_URL}?ep=#{show_id}-#{@filename.season}x#{@filename.episode}"))
      if response['location'] and not response['location'] == '/index.php'
        @url = 'http://www.addic7ed.com/' + response['location']
      else
        raise EpisodeNotFoundError
      end
    end
  end
end
