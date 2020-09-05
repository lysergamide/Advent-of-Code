#!/usr/bin/env ruby
# frozen_string_literal: true

lines = File.read("./input/08.txt")
            .lines
            .map &:strip

original = lines.sum &:length

count = lines.sum do |x|
         x[1 .. -2].gsub(/\\\\/, ' ')
                   .gsub(/\\"/, ' ')
                   .gsub(/\\x.{2}/, ' ')
                   .length
         end

silver = original - count
gold   = lines.sum{ |x| x.length + x.scan(/(")|(\\)/).size + 2 } - original

puts(
  "Day 08
======
✮: #{silver}
★: #{gold}"
)
