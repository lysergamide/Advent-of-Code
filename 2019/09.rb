#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'

tape = File.read(ARGV.first)
           .split(',')
           .map(&:to_i)

part1, part2 =
  [1, 2].each do |num|
    machine = Interpreter.new(tape)
    machine.input << num
    machine.run
    puts machine.output.to_s
  end

puts(
  "Day 09\n"   \
  "------\n"   \
  "Silver: #{part1}\n" \
  "Gold:   #{part2}"
)
