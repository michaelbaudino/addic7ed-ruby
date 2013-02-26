#!/usr/bin/env ruby

# Ruby modules
require 'open-uri'
# Bundler
require 'rubygems'
require 'bundler/setup'
Bundler.require


doc = Nokogiri::HTML(open("http://www.perdu.com"))

puts doc
