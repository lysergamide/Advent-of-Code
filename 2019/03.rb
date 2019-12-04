#!/usr/bin/env ruby

require "set"

def p1(x)
  cross = []
  watch = [Set.new, Set.new]
  steps = [Hash.new, Hash.new]
  wires = x.lines.map { |l| l.split(",") }

  traverse = ->(wire, track, steps) {
    pos = [0, 0]
    s = 1

    wire.each { |step|
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
    }
  }

  traverse[wires[0], watch[0], steps[0]]
  traverse[wires[1], watch[1], steps[1]]

  cross = watch.inject(&:&)
  puts cross.map { |arr| arr.sum(&:abs) }.min
  puts cross.to_a.map { |arr| steps[0][arr] + steps[1][arr] }.min
end

def p2(x)
  ret = x

  ret
end

slurp = File.read(ARGV.first).chomp

puts p1(slurp)
