#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]].map { Vector[*_1] }

TREES = $<.readlines(chomp: true)
          .flat_map
          .with_index do |line, y|
            line.chars.map.with_index { |v, x| [Vector[x, y], v.to_i] }
          end
          .to_h

def oob?(pos) =
  !TREES.include?(pos)

def view(pos) = 
  DIRS.map do |dir|
    (1..).lazy
         .map  { _1 * dir + pos }
         .find { oob?(_1) || TREES[_1] >= TREES[pos] }
         .then do |p2|
           delta = (pos - p2).norm.to_i
           oob?(p2) ? [true, delta.pred] : [false, delta]
         end
  end
  .transpose
  .then { [_1.reduce(:|), _2.reduce(:*)] }

puts TREES.keys
          .map { view _1 }
          .transpose
          .then { [_1.count(&:itself), _2.max] }