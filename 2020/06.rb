#!/usr/bin/env ruby -w
# frozen_string_literal: true

groups = File.read("input/06.txt").split("\n\n").map { _1.split.map &:chars }

silver = groups.sum { _1.reduce(:|).size }
gold = groups.sum { _1.reduce(:&).size }

puts(
  "Day 05\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
# golf
# p $<.read.split("\n\n").map { _1.split.map &:chars }.then { |l| [:|, :&].map { |f| l.sum{ _1.reduce(f).size } } }
