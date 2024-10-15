#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ostruct'

STEPS, lines = $<.read.split(/\n{2,}/)
NODES = lines.split(/\n+/).map do |ln|
  /(?<name>\w+) = \((?<left>\w+),\s+(?<right>\w+)\)/ =~ ln
  [name, OpenStruct.new({ name:, left:, right: })]
end.to_h

def walk_steps(start, itr = 0)
  current = NODES[start]
  until yield(current.name)
    current = if STEPS[itr % STEPS.size] == 'L'
                NODES[current.left]
              else
                NODES[current.right]
              end
    itr += 1
  end
  itr
end

puts walk_steps('AAA') { _1 == 'ZZZ' }
periods = NODES.values.map(&:name).select { _1 == 'A' }.map do |start|
  walk_steps(start) { _1[-1] == 'Z' }
end
puts periods.reduce(&:lcm)
