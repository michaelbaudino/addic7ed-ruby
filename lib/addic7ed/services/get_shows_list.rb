module Addic7ed
  class GetShowsList
    include Service

    def call
      @@shows ||= Nokogiri::HTML(addic7ed_homepage.body).css("select#qsShow option:not(:first-child)").map(&:text)
    end

  private

    def addic7ed_homepage
      Net::HTTP.start("www.addic7ed.com") do |http|
        request = Net::HTTP::Get.new("/")
        request["User-Agent"] = USER_AGENTS.sample
        http.request(request)
      end
    end
  end
end
