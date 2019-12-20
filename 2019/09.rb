#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'

tape = File.read(ARGV.first)
           .split(',')
           .map(&:to_i)

silver, gold =
  [1, 2].map do |num|
    machine = Interpreter.new(tape)
    machine.input << num
    machine.run
    machine.output.first
  end

puts(
  "Day 09\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
