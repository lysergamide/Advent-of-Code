#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

I = $<.read.strip

def solve(n)
  I.chars.each_cons(n).with_index.find { _1.first.uniq.size == n }.last + n
end

puts "Day 06\n",
     "============================\n",
     "✮: #{solve 4}\n",
     "★: #{solve 14}"
