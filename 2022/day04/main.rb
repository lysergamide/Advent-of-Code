#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

I = $<.readlines(chomp: true)
      .map { |ln| ln.gsub("-", "..").split(",").map { eval(_1).to_set } }
      .map { [_1.map(&:size).min, _1.reduce(:&).size] }

Silver = I.count { _1 == _2 }
Gold   = I.count { _2 > 0 }

puts "Day 04\n",
     "============================\n",
     "✮: #{Silver}\n",
     "★: #{Gold}"

# sheks solution
#p $<.readlines
#    .map { |ln| ln.scan(/\d+/).map(&:to_i).each_slice(2).sort_by { [_1, -_2] } }
#    .map { |(_, x), xs| xs.map { _1 <= x ? 1 : 0 } }
#    .reduce { _1.zip(_2).map &:sum }