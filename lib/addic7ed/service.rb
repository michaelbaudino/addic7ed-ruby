# frozen_string_literal: true

module Addic7ed
  module Service
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def call(*args)
        new(*args).call
      end
    end
  end
end
