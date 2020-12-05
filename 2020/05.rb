#!/usr/bin/env ruby -w
# frozen_string_literal: true

seats = File.readlines("input/05.txt").map { _1.tr("FBLR", "0101").to_i 2 }.sort

silver = seats.last
gold = seats.each_with_index.find { |x, i| x + 2 == seats[i + 1] }.first + 1

puts(
  "Day 05\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
