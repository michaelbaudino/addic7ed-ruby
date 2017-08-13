# frozen_string_literal: true

require "singleton"

module Addic7ed
  class GetShowsList
    include Singleton

    def self.call
      instance.call
    end

    def call
      @shows ||= homepage_body.css("select#qsShow option").to_a[1..-1].map(&:text)
    end

    private

    def homepage_body
      Oga.parse_html(addic7ed_homepage.body)
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
