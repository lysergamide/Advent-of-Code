#!/usr/bin/env ruby
# frozen_string_literal: true

I = $<.each_char

def solve(n) =
  I.each_cons(n)
   .with_index
   .find { _1.first.uniq.size == n }
   .last + n

puts "Day 06\n",
     "============================\n",
     "✮: #{solve 4}\n",
     "★: #{solve 14}"
