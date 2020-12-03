#!/usr/bin/env ruby
# frozen_string_literal: true

LINES = File.readlines("input/03.txt", chomp: true)

def solve(x, y)
  LINES.each_with_index
    .select { _2 % y == 0 }
    .count { |line, i| line[(i * x) % line.length] == "#" }
end

silver = solve(3, 1)
gold = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map { solve(*_1) }.reduce :*

puts(
  "Day 02\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
