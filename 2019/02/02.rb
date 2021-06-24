#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'

tape = File.read(ARGV.first)
           .chomp
           .split(',')
           .map(&:to_i)

silver = Interpreter.new(tape, true)
                   .run(12, 2)

gold =
  (0..99).to_a
         .permutation(2)
         .find { |a, b| Interpreter.new(tape).run(a, b) == 19_690_720 }
         .then { |a, b| a * 100 + b }

puts(
  "Day 02\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)