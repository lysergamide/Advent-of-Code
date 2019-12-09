#!/usr/bin/env ruby
# frozen_string_literal: true

require "./intcode/intcode.rb"

tape =
  File.read(ARGV.first)
      .split(",")
      .map(&:to_i)

[1, 5].each do |i|
  machine = Interpreter.new(tape)
  machine.input << i
  machine.run

  puts machine.output.last
end
