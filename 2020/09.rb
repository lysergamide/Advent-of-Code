#!/usr/bin/env ruby -w
# frozen_string_literal: true

require "set"
I = File.readlines("input/09.txt").map(&:to_i)

silver = I[25..].find.with_index { |n, i|
  pre = I[i...i + 25].to_set
  pre.none? { pre.include? n - _1 }
}

gold = [0, 1].then { |i, j|
  until (sum = (range = I[i..j]).sum) == silver do sum > silver ? i += 1 : j += 1 end
  range.minmax.sum
}

puts(
  "Day 09\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
