#!/usr/bin/env ruby
# frozen_string_literal: true

def look_and_say(x)
  ret   = []
  count = 0
  val   = x.first

  x.each_index do |i|
    if x[i] == val
      count += 1
    else
      ret << count << val
      count, val = 1, x[i]
    end
  end
  ret << count << val

  ret
end

input = File.read("10.txt")
            .strip
            .chars

silver = 40.times { input = look_and_say input }.then { input.length }
gold   = 10.times { input = look_and_say input }.then { input.length }

puts("
 Day 10
========
✮: #{silver}
★: #{gold}")
