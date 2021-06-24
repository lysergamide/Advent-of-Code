#!/usr/bin/env ruby 
# frozen_string_literal: true
require "set"

# class Tile
#   def initialize
#     @arr = []
#   end
#
#   def top_edge() @arr.first end
#   def right_edge() @arr.map { _1.last }.join end
#   def left_edge() @arr.map { _1.last }.join end
#   def bottom_edge() @arr.last end
#   def rot_left() @arr = @arr.map(&:reverse).transpose end
#   def rot_right() @arr = @arr.reverse.transpose end
#
#   def all_edges
#     ret = [@top_edge, @right_edge, @left_edge, @bottom_edge]
#     ret + ret.map(&:reverse)
#   end
# end

# jesus christ how horrifying

I = File.read("input/20.txt")
  .split("\n\n")
  .map {
  /Tile (?<id>\d+):\n(?<tile>.*)/m =~ _1
  [id.to_i, tile.split("\n").map(&:chars)]
}.to_h

def rotate(arr)
  arr.map(&:reverse).transpose
end

E = I.map { |key, tile|
  [key,
   4.times
    .map { ret = tile.first.join; tile = rotate(tile); ret }
    .then { _1 + _1.map(&:reverse) }
    .flatten]
}.to_h

CON = Hash.new { |h, k| h[k] = 0 }.tap do |h|
  E.each_value.to_a.flatten.map { h[_1] += 1 }
end

def silver
  I.each_key.filter { |k| E[k].count { CON[_1] == 1 } == 4 }
end

def solve_grid
  name = silver.first
  tile = I[name]
  pivot = E[silver.first].each_cons(2)
    .with_index
    .find { |es, i| es.all? { CON[_1] == 1 } }
    .last

  ((pivot + 1) % 4).times.map { tile = rotate(tile) }

  grid = [[tile]]
  remaining = Set.new(E.each_key.to_a - [name])

  until remaining.empty?
    edge = grid.last.last.map { _1.last }.join
    name = remaining.find { E[_1].include? edge }

    if name.nil?
      edge = grid.last.first.last.join
      name = remaining.find { E[_1].include? edge }
      tile = I[name]

      pivot = E[name].each_index.find { E[name][_1] == edge }

      (pivot % 4).times { tile = rotate(tile) }
      tile = tile.map(&:reverse) if pivot > 3

      grid << [tile]
    else
      tile = I[name]
      pivot = E[name].each_index.find { E[name][_1] == edge }

      ((pivot + 1) % 4).times { tile = rotate(tile) }
      tile = tile.reverse if pivot <= 3
      grid.last << tile
    end

    remaining.delete name
  end

  grid
end

def gold
  grid = solve_grid.map { |row| row.map { |tile| tile[1...-1].map { _1[1...-1] } } }
    .map { |row| row.transpose }
    .reduce(&:+)
    .map { _1.reduce(&:+) }

  dragon = [
    "..................#.",
    "#....##....##....###",
    ".#..#..#..#..#..#...",
  ].freeze

  search = ->() do
    count = 0
    (0...grid.size - dragon.size).each do |i|
      (0...grid[0].size - dragon[0].size).each do |j|
        if (0..2).all? { /^#{dragon[_1]}/ =~ grid[i + _1].join[j...] }
          count += 1
        end
      end
    end
    count
  end

  count = 0
  4.times { count = search.call; break if count > 0; grid = rotate(grid) }
  if count.zero?
    grid = grid.map &:reverse
    4.times { count = search.call; break if count > 0; grid = rotate(grid) }
  end

  grid.flatten.count("#") - (dragon.join.count("#") * count)
end

puts("Day 20\n" \
"==================\n" \
"✮: #{silver.reduce(&:*)}\n" \
"★: #{gold}")
