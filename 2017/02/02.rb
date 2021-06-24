#!/usr/bin/env ruby
# frozen_string_literal: true

lines = File.readlines(ARGV.first)

num_rows = lines.map { |l| l.split(' ').map(&:to_i).sort }

puts(num_rows.sum { |row| row.last - row.first })

puts(
  num_rows.sum do |row|
    row.combination(2).find do |pair|
      (pair.last % pair.first).zero?
    end.reverse
       .inject(:/)
  end
)
