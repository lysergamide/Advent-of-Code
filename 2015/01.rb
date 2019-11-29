#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.open(ARGV.first).read.chomp

floor = 0
basement = nil

input.chars.each_with_index do |c, i|
  floor += c == '(' ? 1 : -1

  if basement.nil? && floor < 0
    found = true
    basement = i
  end
end

puts floor
puts basement
