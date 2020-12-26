#!/usr/bin/env ruby 
# frozen_string_literal: true
require "pp"

I = File.read("input/15.txt").split(",").each_with_index.map { [_1.to_i, _2 + 1] }.to_h

silver, gold = [2020, 30000000].map do |n|
  turns = I.clone
  last_n, index = turns.max_by { _2 }

  (index...n).each do |i|
    next_n = turns.include?(last_n) ? i - turns[last_n] : 0
    turns[last_n] = i
    last_n = next_n
  end

  last_n
end

puts("Day 15\n" \
"==================\n" \
"✮: #{silver}\n" \
"★: #{gold}")
