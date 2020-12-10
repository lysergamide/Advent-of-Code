#!/usr/bin/env ruby -w
# frozen_string_literal: true

N = [0] + File.readlines("input/10.txt").map(&:to_i).sort.then { _1 + [_1.last + 3] }

silver = [1, 3].map { |n| N.each_cons(2).count { _2 - _1 == n } }.reduce(&:*)

gold = Hash.new { |h, k| h[k] = 0 }.then { |h|
  h[0] = 1
  N.each { h[_1] += h[_1 - 1] + h[_1 - 2] + h[_1 - 3] }
  h[N.last]
}

puts(
  "Day 10\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
