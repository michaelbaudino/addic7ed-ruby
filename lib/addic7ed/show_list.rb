module Addic7ed
  class ShowList
    class << self
      def find(raw_name)
        encoded_name = encoded_name(raw_name)
        puts "Searching for '#{human_name(raw_name)}' in Addic7ed list"
        human_name = human_name(raw_name)
        encoded_name(human_list.select{ |i| i.downcase == human_name.downcase }.first)
      end

      private

      def human_name(raw_name)
        raw_name.
          gsub(/[_\.]+/, ' ').
          gsub(/ (US|UK)( |$)/i, ' (\1)\2').
          gsub(/ (\d{4})( |$)/i, ' (\1)\2')
      end

      def encoded_name(human_name)
        human_name.gsub(' ', '_')
      end

      def human_list
        @@human_list ||= Nokogiri::HTML(addic7ed_homepage.body).css("select#qsShow option:not(:first-child)").map do |node|
          node.text
        end
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
end
