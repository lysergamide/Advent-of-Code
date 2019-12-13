#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'

tape =
  File.read(ARGV.first)
      .split(',')
      .map(&:to_i)

part1, part2 =
  [1, 5].map do |i|
    machine = Interpreter.new(tape)
    machine.input << i
    machine.run

    machine.output.last
  end

puts(
  "Day 05\n"   \
  "------\n"   \
  "Silver: #{part1}\n" \
  "Gold:   #{part2}"
)
