#!/usr/bin/env ruby
# frozen_string_literal: true

PAD = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
].freeze

PAD2 = [
  [nil, nil, 1, nil, nil],
  [nil, 2, 3, 4, nil],
  [5, 6, 7, 8, 9],
  [nil, 'A', 'B', 'C', nil],
  [nil, nil, 'D', nil, nil]
].freeze

class Pair
  attr_accessor :x, :y

  def initialize(x, y, pad)
    @x = x
    @y = y
    @pad = pad
  end

  def to_s
    [@x, @y].to_s
  end

  def key
    @pad[@y][@x]
  end

  def move(dir)
    y_offset = (@pad.size - @pad.count { |a| !a[@x].nil? }) / 2
    x_offset = (@pad[@y].size - @pad[@y].count { |a| !a.nil? }) / 2

    y_min = 0 + y_offset
    x_min = 0 + x_offset
    y_max = @pad.size - y_offset - 1
    x_max = @pad.size - x_offset - 1

    case dir
    when 'U' then @y -= @y > y_min ? 1 : 0
    when 'D' then @y += @y < y_max ? 1 : 0
    when 'L' then @x -= @x > x_min ? 1 : 0
    when 'R' then @x += @x < x_max ? 1 : 0
    end
  end
end

pos = Pair.new(1, 1, PAD)
pos2 = Pair.new(0, 2, PAD2)

stack = []
stack2 = []
input = File.open(ARGV.first)
            .readlines
            .map(&:chomp)

input.each do |ls|
  ls.each_char { |c| pos.move c; pos2.move c }

  stack << pos.key
  stack2 << pos2.key
end

puts stack.to_s
puts stack2.to_s
