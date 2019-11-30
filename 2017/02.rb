#!/usr/bin/env ruby

lines = File.readlines(ARGV.first)

num_rows = lines.map { |l| l.split(" ").map(&:to_i).sort }

puts num_rows.sum { |row| row.last - row.first }

puts num_rows.sum { |row|
  row.combination(2).find { |pair|
    (pair.last % pair.first).zero?
  }.reverse.inject :/
}
