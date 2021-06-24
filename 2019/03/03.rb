#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

# brute force
def traverse(wire)
  track = Set.new
  steps = {}
  pos = [0, 0]

  s = 1
  wire.each do |step|
    step[1..-1].to_i.times do
      case step[0]
      when 'U' then pos[1] += 1
      when 'D' then pos[1] -= 1
      when 'R' then pos[0] += 1
      when 'L' then pos[0] -= 1
      end

      track << pos.dup
      steps.store(pos.dup, s.dup)
      s += 1
    end
  end

  [track, steps]
end

def find_cross(w1, w2)
  tracks, steps = traverse(w1).zip(traverse(w2))

  cross  = tracks.inject(&:&)
  silver = cross.map { |arr| arr.sum(&:abs) }.min
  gold   = cross.to_a.map { |arr| steps[0][arr] + steps[1][arr] }.min

  [silver, gold]
end

wires = File.readlines(ARGV.first)
            .map { |s| s.split(',') }

silver, gold = find_cross(*wires)

puts(
  "Day 03\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)