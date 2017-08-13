# frozen_string_literal: true

require "json"

module Addic7ed
  CONFIG_FILE  = File.join(File.dirname(__FILE__), "config.json").freeze
  CONFIG       = JSON.parse(File.read(CONFIG_FILE), symbolize_names: true).freeze
  LANGUAGES    = CONFIG[:languages].freeze
  USER_AGENTS  = CONFIG[:user_agents].freeze
  SHOWS_URL    = CONFIG[:urls][:shows].freeze
  EPISODES_URL = CONFIG[:urls][:episodes].freeze

  COMPATIBILITY_720P = {
    "LOL"  => "DIMENSION",
    "SYS"  => "DIMENSION",
    "XII"  => "IMMERSE",
    "ASAP" => "IMMERSE"
  }.freeze
end
