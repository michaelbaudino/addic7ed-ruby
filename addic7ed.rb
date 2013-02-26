#!/usr/bin/env ruby

# Ruby modules
require 'open-uri'
# Bundler
require 'rubygems'
require 'bundler/setup'
Bundler.require
# Local modules
require './lib/addic7ed-filename'

filename = '/data/public/Series/The Walking Dead/Saison 03/The.Walking.Dead.S03E09.720p.HDTV.x264-EVOLVE.mkv'

begin
  file = Addic7ed::Filename.new(filename)
  puts file
rescue Exception => e
  puts "Error: #{e.message}"
  puts 'Aborting.'
end

# shows_ids = {}
# seasons_ids = {}
# episodes_ids = {}

# shows_url = "http://www.addic7ed.com/ajax_getShows.php"
# seasons_url = "http://www.addic7ed.com/ajax_getSeasons.php"
# episodes_url = "http://www.addic7ed.com/ajax_getEpisodes.php"

# # Fetch shows list
# Nokogiri::HTML(open(shows_url)).css('option').each do |show_html|
#   shows_ids[show_html.content] = show_html['value']
# end

