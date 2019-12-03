#!/usr/bin/env ruby

require "./machine.rb"

tape = File.read(ARGV.first).chomp.split(",").map &:to_i
cpu = Machine.new tape

puts cpu.run(2, 12)

(0..99).to_a.permutation(2)
  .find { |a, b| cpu.run(a, b) == 19690720 }
  .tap { |a, b| puts a * 100 + b }
