#!/usr/bin/env ruby
# frozen_string_literal: true

require "./intcode.rb"

slurp = File.read(ARGV.first)
tape = slurp.split(",").map(&:to_i)
cpu = Machine.new tape
cpu.run
