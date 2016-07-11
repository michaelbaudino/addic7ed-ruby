module Addic7ed
  class SubtitlesCollection < Array
    def compatible_with(group)
      select { |subtitle| CheckCompatibility.call(subtitle, group) }
    end

    def completed
      select(&:completed?)
    end

    def most_popular
      sort_by(&:downloads).last
    end

  private

    def select
      SubtitlesCollection.new(super)
    end
  end
end
