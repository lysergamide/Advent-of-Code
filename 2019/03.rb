#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

# brute force
def find_cross(x)
  watch = [Set.new, Set.new]
  steps = [{}, {}]
  wires = x.lines.map { |l| l.split(",") }

  traverse = lambda { |wire, track, steps|
    pos = [0, 0]
    s = 1

    wire.each do |step|
      step[1..-1].to_i.times do
        case step[0]
        when "U" then pos[1] += 1
        when "D" then pos[1] -= 1
        when "R" then pos[0] += 1
        when "L" then pos[0] -= 1
        end

        track << pos.dup
        steps.store(pos.dup, s.dup)
        s += 1
      end
    end
  }

  traverse[wires[0], watch[0], steps[0]]
  traverse[wires[1], watch[1], steps[1]]

  cross = watch.inject(&:&)
  ret1 = cross.map { |arr| arr.sum(&:abs) }.min
  ret2 = cross.to_a.map { |arr| steps[0][arr] + steps[1][arr] }.min

  [ret1, ret2]
end

slurp = File.read(ARGV.first).chomp

puts find_cross(slurp)
