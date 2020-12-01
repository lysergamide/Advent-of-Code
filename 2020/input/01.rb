#!/usr/bin/env ruby
# frozen_string_literal: true

require "re"
require "set"

input = File.open("input/01.txt").read.strip

silver = input.split("").map { |x| x }.reduce
gold = nil

puts(
  "Day 01\n" \
  "======\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
