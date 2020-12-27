#!/usr/bin/env ruby
# frozen_string_literal: true

fp = "input/02.txt"

silver, gold = 0, 0

File.readlines(fp, chomp: true).each do |line|
  a, b, c, d = line.tr("-:", " ").split
  a = a.to_i
  b = b.to_i
  count = d.count c

  silver += 1 if b >= count && count >= a
  gold += 1 if (d[a - 1] == c) ^ (d[b - 1] == c)
end

puts(
  "Day 02\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
