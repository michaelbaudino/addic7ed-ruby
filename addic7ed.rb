#!/usr/bin/env ruby

# Ruby modules
require 'open-uri'
require 'optparse'
require 'net/http'
# Bundler
require 'rubygems'
require 'bundler/setup'
Bundler.require
# Local modules
require './lib/addic7ed-errors'
require './lib/addic7ed-common'
require './lib/addic7ed-episode'
require './lib/addic7ed-subtitle'

VERSION="0.0.3"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: addic7ed.rb [options] <file1> [<file2>, <file3>, ...]"

  opts.on("-l [LANGUAGE]", "--language [LANGUAGE]", "Language code to look subtitles for (default: French)") do |l|
    options[:language] = l
  end

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-q", "--quiet", "Run without output (cron-mode)") do |q|
    options[:quiet] = q
  end

  opts.on("-d", "--debug", "Debug mode [do not use]") do |d|
    options[:debug] = d
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  opts.on_tail("-L", "--list-languages", "List all available languages") do
    puts "All available languages (with their corresponding ISO code):"
    Addic7ed::LANGUAGES.each do |lang, infos|
      puts "#{lang}:\t#{infos[:name]}"
    end
    exit
  end

  opts.on_tail("-V", "--version", "Show version number") do
    puts "This is addic7ed-ruby version #{VERSION} by Michael Baudino (https://github.com/michaelbaudino)"
    exit
  end
end.parse!

options[:filenames] = ARGV
options[:language] ||= 'fr'

# Main loop over mandatory arguments (e.g. filenames)

options[:filenames].each do |filename|
  unless File.file? filename or options[:debug]
    puts "Warning: #{filename} does not exist or is not a regular file. Skipping." unless options[:quiet]
    next
  end

  begin
    sub = Addic7ed::Subtitle.new(filename)
    puts "!!! Episode URL is : #{sub.episode_url}"
  rescue Addic7ed::InvalidFilenameError
    puts "Warning: #{filename} does not seem to be a valid TV show filename. Skipping." unless options[:quiet]
    next
  rescue Addic7ed::ShowNotFoundError
    puts "Warning: Show not found on Addic7ed : #{sub.episode.showname}. Skipping."
    next
  rescue Addic7ed::EpisodeNotFoundError
    puts "Warning: Episode not found on Addic7ed : #{sub.episode.showname} S#{sub.episode.season}E#{sub.episode.episode}. Skipping."
    next
  end

end