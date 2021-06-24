#!/usr/bin/env ruby
# frozen_string_literal: true

str = File.read(ARGV.first).chomp

def solve(str, rot)
  sarr = str.chars

  (0..str.length - 1).sum do |i|
    if sarr[i] == sarr[(i + rot) % str.size]
      sarr[i].to_i
    else
      0
    end
  end
end

puts solve(str, 1)
puts solve(str, str.size / 2)
