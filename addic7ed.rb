#!/usr/bin/env ruby

# Ruby modules
require 'open-uri'
require 'optparse'
# Bundler
require 'rubygems'
require 'bundler/setup'
Bundler.require
# Local modules
require './lib/addic7ed-filename'

VERSION="0.0.3"

options = {}
OptionParser.new do |opts|
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-f [FILENAME]", "--filename [FILENAME]", "File to look subtitles for") do |f|
    options[:filename] = f
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  opts.on_tail("-V", "--version", "Show version number") do
    puts "This is addic7ed-ruby version #{VERSION} by Michael Baudino (https://github.com/michaelbaudino)"
    exit
  end
end.parse!

puts "Verbose:  #{options[:verbose]}"
puts "Filename: #{options[:filename]}"

# begin
#   file = Addic7ed::Filename.new(filename)
#   puts file
# rescue Exception => e
#   puts "Error: #{e.message}"
#   puts 'Aborting.'
# end

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

