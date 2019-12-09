#!/usr/bin/env ruby
# frozen_string_literal: true

require "./intcode/intcode.rb"

input = File.read(ARGV.first)
            .chomp
            .split(",")
            .map(&:to_i)

[1,2].each do |num|
  machine = Interpreter.new(input)
  machine.input << num
  machine.run
  puts machine.output.to_s
end
