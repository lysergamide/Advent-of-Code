#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require './intcode/intcode.rb'

class Ord
  attr_accessor :val

  North = 0
  East  = 1
  South = 2
  West  = 3
  MAX   = 4

  def initialize(x: North)
    @val = x
  end

  def rot(x)
    @val += x.zero? ? -1 : 1
    @val %= 4
  end

end

class Array
  def move(dir)
    case dir.val
    when Ord::North then self[0] -= 1
    when Ord::East  then self[1] += 1
    when Ord::South then self[0] += 1
    when Ord::West  then self[1] -= 1
    end
  end
end

def paint(tape, black: Set.new, white: Set.new)
  dir   = Ord.new
  pos   = [0, 0]
  paint = true

  machine = Interpreter.new(tape)
  until machine.done
    machine.input[0] = white.include?(pos) ? 1 : 0
    machine.opcycle

    next if machine.output.empty?

    out = machine.output.pop
    if paint
      if out.zero?
        black << pos.dup
        white.delete(pos)
      else
        white << pos.dup
        black.delete(pos)
      end
    else
      dir.rot(out)
      pos.move(dir)
    end

    paint ^= true
  end

  [white, black]
end

def paint_canvas(white, black)
  min_y, max_y = (white + black).map(&:first).minmax
  min_x, max_x = (white + black).map(&:last).minmax

  paint_line =
    lambda (line, y) do
      line.map
          .with_index { |c, x| 
            y -= min_y
            x -= min_x
            white.include?([y, x]) ? '██' : '░░'
          }
          .join
    end

  canvas = Array.new(max_y + 1, Array.new(max_x + 1))
  canvas.map
        .with_index(&paint_line)
        .join("\n")
end

tape = File.read(ARGV.first)
           .split(',')
           .map(&:to_i)

silver = paint(tape).reduce(:|).size
gold   = paint_canvas(*paint(tape, :white => Set.new([[0, 0]])))

puts(
  "Day 11\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: \n#{gold}"
)