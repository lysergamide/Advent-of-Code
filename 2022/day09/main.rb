#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'
require 'parallel'

V = Vector
I = $<.readlines(chomp: true).map &:split

DIRS = { 'R' => V[1, 0], 'U' => V[0, 1], 'L' => V[-1, 0], 'D' => V[0, -1] }.freeze

def movement(x0, x1) = (x0 - x1).normalize.map { _1 > 0 ? _1.ceil : _1.floor }

def solve(size)
  I.reduce([Set[], (0 ... size).map { V[0, 0] }]) do |(seen, xs), (dir, n)|
    n.to_i.times do
      xs[0] += DIRS[dir]

      (1 ... xs.size).each do |idx|
        pred = xs[idx - 1] 
        curr = xs[idx]

        xs[idx] += movement(pred, curr) if (pred - curr).norm >= 2
      end

      seen << xs.last
    end
    [seen, xs]
  end
  .first
  .size
end

puts Parallel.map([2, 10]) { solve _1 }