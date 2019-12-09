#!/usr/bin/env ruby
# frozen_string_literal: true

require "./intcode/intcode.rb"

tape = File.read(ARGV.first)
           .chomp
           .split(",")
           .map(&:to_i)

puts Interpreter.new(tape, true).run(12, 2)

(0..99).to_a
       .permutation(2)
       .find { |a, b| Interpreter.new(tape).run(a, b) == 19_690_720 }
       .tap { |a, b| puts a * 100 + b }
