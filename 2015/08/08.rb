#!/usr/bin/env ruby
# frozen_string_literal: true

lines = File.readlines("08.txt", chomp: true)

original = lines.sum &:length

count = lines.sum do |x|
  x[1 .. -2].gsub(/(\\\\|\\"|\\x.{2})/, ' ').length
end

silver = original - count
gold   = lines.sum{ |x| x.length + x.scan(/(")|(\\)/).size + 2 } - original

puts(
  "Day 08
======
✮: #{silver}
★: #{gold}"
)
