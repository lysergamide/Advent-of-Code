#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"
I = File.readlines("input/17.txt")

def neighbors(p) (p.map { (_1 - 1.._1 + 1).to_a }.then { |a, *b| a.product(*b) }) - [p] end

def solve(p2 = false)
  alive = I.each_index
           .flat_map { |i| (0...I[0].size).map { |j| p2 ? [i, j, 0, 0] : [i, j, 0] if I[i][j] == "#" } }
           .compact
           .to_set

  6.times do
    alive = Hash.new { |h, k| h[k] = 0 }
                .tap { |h| alive.each { |cube| neighbors(cube).each { h[_1] += 1 } } }
                .then { |h| h.each_key.filter { h[_1] == 3 || (alive.include?(_1) && h[_1] == 2) } }
                .to_set
  end

  alive.size
end

puts("Day 17\n" \
"==================\n" \
"✮: #{solve}\n" \
"★: #{solve true}")
