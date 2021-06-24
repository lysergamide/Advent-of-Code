#!/usr/bin/env ruby 
# frozen_string_literal: true

G = File.readlines("input/07.txt").map { |line|
  (_, bag), *children = line.scan(/(^|\d+\s)(\w+\s\w+)/)
  [bag, children.map { [_1.to_i, _2] }]
}.to_h

T = "shiny gold"

def part1(b) b == T || G[b].any? { part1(_1.last) } end
def part2(b) G[b].sum { _1 * (1 + part2(_2)) } end

silver = G.count { part1(_1.first) } - 1
gold = part2(T)

puts(
  "Day 07\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
