#!/usr/bin/env ruby
# frozen_string_literal: true

PAD = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
].freeze

PAD2 = [
  [nil, nil, 1, nil, nil],
  [nil, 2, 3, 4, nil],
  [5, 6, 7, 8, 9],
  [nil, "A", "B", "C", nil],
  [nil, nil, "D", nil, nil],
].freeze

class Pair
  attr_accessor :x, :y

  def initialize(x, y, pad)
    @x   = x
    @y   = y
    @pad = pad
  end

  def to_s
    [@x, @y].to_s
  end

  def key
    @pad[@y][@x]
  end

  def move(dir)
    y_max = @pad.length
    diff  = (y_max - @pad[@y].compact.length) / 2

    y_max -= 1

    x_min = 0 + diff
    x_max = y_max - diff

    case dir
    when "U" then @y -= @y > 0     ? 1 : 0
    when "D" then @y += @y < y_max ? 1 : 0
    when "L" then @x -= @x > x_min ? 1 : 0
    when "R" then @x += @x < x_max ? 1 : 0
    end
  end
end

pos  = Pair.new(1, 1, PAD)
pos2 = Pair.new(2, 2, PAD2)

stack  = []
stack2 = []
input  = File.open(ARGV.first)
            .readlines
            .map(&:compact)
            .compact

input.each do |ls|
  ls.each_char { |c| pos.move c; pos2.move c }

  stack  << pos.key
  stack2 << pos2.key
end

puts stack.to_s
puts stack2.to_s
