#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.open(ARGV.first)
            .read
            .chomp

floor = 0
basement = nil

input.chars.each_with_index do |c, i|
  floor += c == '(' ? 1 : -1

  basement = i if basement.nil? && floor.negative?
end

puts "Day 01
------
Silver: #{floor}
Gold:   #{basement}
"
