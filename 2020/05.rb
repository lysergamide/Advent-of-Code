#!/usr/bin/env ruby 
# frozen_string_literal: true

seats = File.readlines("input/05.txt").map { _1.tr("FBLR", "0101").to_i 2 }.sort

silver = seats.last
gold = seats.each_cons(2).find { _1 + 2 == _2 }.first + 1

puts(
  "Day 05\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)

# golfed version
# puts File.readlines("input/05.txt").map { _1.tr("FBLR", "0101").to_i 2 }.sort
#    .then { |l| [l[-1], l.each_cons(2).find { _1 + 2 == _2 }[0] + 1] }
