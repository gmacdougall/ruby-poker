#!/usr/bin/env ruby

$LOAD_PATH << './lib'
require 'card'
require 'hand'
require 'hand_rank'
require 'rank'

ARGF.each do |line|
  hands = line.split('|').map { |h| Hand.parse(h) }
  max = hands.max
  puts "#{line.strip}, Winner: #{hands.select { |h| h == max }.join(', ')}, Rank: #{max.rank_string}"
end
