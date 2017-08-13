# frozen_string_literal: true

module Addic7ed
  class CheckCompatibility
    include Service

    attr_reader :subtitle, :group

    def initialize(subtitle, group)
      @subtitle = subtitle
      @group    = group
    end

    def call
      defined_as_compatible? || generally_compatible? || commented_as_compatible?
    end

    private

    def defined_as_compatible?
      subtitle.version.split(",").include? group
    end

    def generally_compatible?
      COMPATIBILITY_720P[subtitle.version] == group || COMPATIBILITY_720P[group] == subtitle.version
    end

    def commented_as_compatible?
      return false if comment_explicitely_wont_work?
      return false if comment_is_a_resync?
      comment_matches_a_compatible_group?
    end

    def comment_matches_a_compatible_group?
      !Regexp.new("(#{compatible_groups.join("|")})", "i").match(subtitle.comment).nil?
    end

    def comment_explicitely_wont_work?
      !/(won'?t|doesn'?t|not) +work/i.match(subtitle.comment).nil?
    end

    def comment_is_a_resync?
      !/resync +(from|of|for)/i.match(subtitle.comment).nil?
    end

    def compatible_groups
      @compatible_groups ||= [
        group,
        COMPATIBILITY_720P[group],
        COMPATIBILITY_720P[subtitle.version]
      ].compact.uniq
    end
  end
end
