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
  opts.banner = "Usage: addic7ed.rb [options] <file1> [<file2>, <file3>, ...]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-l [LANGUAGE]", "--language [LANGUAGE]", "Language to look subtitles for") do |l|
    options[:language] = l
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

options[:filenames] = ARGV

puts "Verbose:  #{options[:verbose]}"
puts "Filenames: #{options[:filenames]}"
puts "Language: #{options[:language]}"

options[:filenames].each do |filename|
  unless File.file? filename
    puts "Warning: #{filename} does not exist or is not a regular file. Skipping."
  end

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

end