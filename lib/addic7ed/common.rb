require "json"

module Addic7ed
  CONFIG       = JSON.load(File.open("lib/addic7ed/config.json"), nil, symbolize_names: true).freeze
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
