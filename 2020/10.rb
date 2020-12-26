#!/usr/bin/env ruby 
# frozen_string_literal: true

N = [0] + File.readlines("input/10.txt").map(&:to_i).sort.then { _1 << _1.last + 3 }

silver = N[...-1].zip(N[1..]).map { _2 - _1 }.then { _1.count(1) * _1.count(3) }
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
