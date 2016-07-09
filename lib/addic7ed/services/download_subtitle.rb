module Addic7ed
  class DownloadSubtitle
    include Service

    HTTP_REDIRECT_LIMIT = 8

    attr_reader :url, :filename, :referer, :redirect_count

    def initialize(url, filename, referer, redirect_count = 0)
      @url                 = url
      @filename            = filename
      @referer             = referer
      @redirect_count = redirect_count
    end

    def call
      raise DownloadError, "Too many HTTP redirections" if redirect_count >= HTTP_REDIRECT_LIMIT
      raise DailyLimitExceeded, "Daily limit exceeded"  if %r{^/downloadexceeded.php} =~ url
      return follow_redirection(response["location"])   if response.is_a? Net::HTTPRedirection
      write(response.body)
    end

  private

    def uri
      @uri ||= URI(url)
    end

    def response
      @response ||= Net::HTTP.start(uri.hostname, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request["Referer"]    = referer # Addic7ed requires the Referer to be correct
        request["User-Agent"] = USER_AGENTS.sample
        http.request(request)
      end
    rescue
      raise DownloadError, "A network error occured"
    end

    def follow_redirection(location_header)
      # Addic7ed is serving redirection URL not-encoded,
      # but Ruby does not support it (see http://bugs.ruby-lang.org/issues/7396)
      new_url = URI.escape(location_header)
      DownloadSubtitle.call(new_url, filename, url, redirect_count + 1)
    end

    def write(content)
      Kernel.open(filename, "w") do |f|
        f << content
      end
    rescue
      raise DownloadError, "Cannot write to disk"
    end
  end
end
