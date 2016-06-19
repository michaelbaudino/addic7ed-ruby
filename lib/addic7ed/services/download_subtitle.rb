module Addic7ed
  class DownloadSubtitle
    include Service

    HTTP_REDIRECT_LIMIT = 8

    attr_reader :url, :filename, :referer, :http_redirect_count

    def initialize(url, filename, referer, http_redirect_count = 0)
      @url                 = url
      @filename            = filename
      @referer             = referer
      @http_redirect_count = http_redirect_count
    end

    def call
      raise DownloadError.new("Too many HTTP redirections") if http_redirect_count >= HTTP_REDIRECT_LIMIT
      raise DailyLimitExceeded.new("Daily limit exceeded")  if /^\/downloadexceeded.php/.match url
      if response.kind_of? Net::HTTPRedirection
        new_url = URI.escape(response["location"]) # Addic7ed is serving redirection URL not-encoded, but Ruby does not support it (see http://bugs.ruby-lang.org/issues/7396)
        DownloadSubtitle.call(new_url, filename, url, http_redirect_count + 1)
      else
        write(response.body)
      end
    end

  private

    def uri
      @uri ||= URI(url)
    end

    def response
      @response ||= Net::HTTP.start(uri.hostname, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request["Referer"]    = referer            # Addic7ed needs the Referer to be correct
        request["User-Agent"] = USER_AGENTS.sample # User-agent is just here to fake a real browser request
        http.request(request)
      end
    rescue
      raise DownloadError.new("A network error occured")
    end

    def write(content)
      Kernel.open(filename, "w") do |f|
        f << content
      end
    rescue
      raise DownloadError.new("Cannot write to disk")
    end
  end
end
