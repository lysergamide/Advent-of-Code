#!/usr/bin/env ruby -w
# frozen_string_literal: true

groups = File
  .read("input/06.txt")
  .split("\n\n")
  .map { _1.split.map &:chars }

silver = groups.sum { _1.reduce(:|).size }
gold = groups.sum { _1.reduce(:&).size }

puts(
  "Day 06\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)

# golf 90 characters
# $/="\n\n";p$<.map{_1.split.map &:chars}.then{|l|[:|,:&].map{|f|l.sum{ _1.reduce(f).size}}}
# just part1/2 is 56 characters
# $/="\n\n";p$<.sum{_1.split.map(&:chars).reduce(:&).size}
