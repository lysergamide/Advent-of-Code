#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require './intcode/intcode.rb'

class Ord
  attr_accessor :N, :E, :S, :W, :val
  def initialize(x)
    @val = x
  end

  def rot(x)
    @val += x.zero? ? -1 : 1
    @val %= 4
  end

  N   = 0
  E   = 1
  S   = 2
  W   = 3
  MAX = 4
end

def move(dir, arr)
end

tape = File.read(ARGV.first)
           .split(',')
           .map(&:to_i)

direction = Ord.new(0)
pos       = [0, 0]
machine   = Interpreter.new(tape)
black     = Set.new
white     = Set.new
white << [0, 0]

i = 0
until machine.done
  machine.input[0] = white.include?(pos) ? 1 : 0
  machine.opcycle

  next if machine.output.empty?

  out = machine.output.pop
  if i.zero?
    if out.zero?
      black << pos.dup
      white.delete(pos)
    else
      white << pos.dup
      black.delete(pos)
    end
  else
    direction.rot(out)

    case direction.val
    when 0 then pos[0] -= 1
    when 1 then pos[1] += 1
    when 2 then pos[0] += 1
    when 3 then pos[1] -= 1
    end
  end

  i += 1
  i %= 2
end

union = white | black
silver = union.size

grid = Array.new(30) { Array.new(30) }

union.each { |pos|
  y, x = pos
  color = (white.include?(pos) ? '#' : ' ')
  grid[y][x - 1] = color
}

grid.map!(&:compact)
grid.reject!(&:empty?)


grid.each { |x| puts x.join('') }


puts(
  "Day 11\n"   \
  "======\n"   \
  "✮: #{silver}\n" \
  "★: #{gold}"
)

