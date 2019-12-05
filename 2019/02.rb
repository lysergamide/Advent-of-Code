#!/usr/bin/env ruby
# frozen_string_literal: true

require "./intcode.rb"

tape = File.read(ARGV.first).chomp.split(",").map &:to_i
cpu = Machine.new tape

puts cpu.run(2, 12)

(0..99).to_a.permutation(2)
       .find { |a, b| cpu.run(a, b) == 19_690_720 }
       .tap { |a, b| puts a * 100 + b }
