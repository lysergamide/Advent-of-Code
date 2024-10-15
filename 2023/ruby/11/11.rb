#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

xs = Set.new
ys = Set.new

GRID = $<.readlines(chomp: true).map(&:chars)
PLANETS = GRID.each_with_index.flat_map do |row, y|
  row.each_with_index.map do |chr, x|
    next unless chr == '#'

    xs << x
    ys << y
    Vector[x, y]
  end
end.compact

def solve(start, stop, xs, ys)
  ([start[0], stop[0]].sort.then { _1..._2 }).sum { xs.include?(_1) ? 1 : yield } +
    ([start[1], stop[1]].sort.then { _1..._2 }).sum { ys.include?(_1) ? 1 : yield }
end

COMBS = PLANETS.combination(2)
puts(COMBS.sum { |pair| solve(*pair, xs, ys) { 2 } })
puts(COMBS.sum { |pair| solve(*pair, xs, ys) { 1_000_000 } })
