#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

NUMS = File.readlines("input/01.txt")
  .map(&:to_i)
  .to_set

def solve(year = 2020)
  ret = NUMS.find { NUMS.member? year - _1 }

  ret ? ret * (year - ret) : nil
end

silver = solve
gold = NUMS.map {
  tmp = solve(2020 - _1)
  tmp ? tmp * _1 : nil
}.find(&:itself)

puts(
  "Day 01\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
