#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"
require "matrix"

V = Vector
VAL = { "." => "0", "#" => "1" }

ALGO, I = $<.read.strip.split("\n\n")
IMG =
  I
    .split("\n")
    .flat_map
    .with_index { |line, y| line.chars.map.with_index { |c, x| [V[y, x], c] } }
    .to_h
    .tap { |h| h.default = "." }

N = [-1, 0, 1].product([-1, 0, 1]).map { V[*_1] }.freeze
def n9(pos) = N.map { pos + _1 }

def enhance(image)
  oimage = Hash.new(ALGO[(VAL[image[nil]] * 9).to_i(2)])
  min = image.keys.map { _1.to_a.min }.min - 1
  max = image.keys.map { _1.to_a.max }.max + 1

  (min..max).each do |y|
    (min..max).each do |x|
      pos = V[y, x]
      oimage[pos] = ALGO[n9(pos).map { VAL[image[_1]] }.join.to_i(2)]
    end
  end

  oimage
end

iter =
  Enumerator
    .new do |y|
      i = IMG
      loop do
        y << i
        i = enhance(i)
      end
    end
    .lazy.drop 2

Silver = iter.first.values.count "#"
Gold = iter.drop(48).first.values.count "#"

puts "Day 12\n",
     "============================\n",
     "✮: #{Silver}\n",
     "★: #{Gold}"
