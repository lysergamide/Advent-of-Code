# /user/bin/env ruby
# frozen_string_literal: true

require 'matrix'

Fish  = gets(nil).chomp
                 .scan(/\d+/)
                 .map(&:to_i)
                 .reduce(Array.new(9, 0)) { _1[_2] += 1; _1 }
                 .then { Matrix.column_vector _1 }

A = Matrix.build(9, 9) { |r, c| ((r + 1) % 9) == c ? 1 : 0}
          .tap {|a| a[6, 0] = 1}

def solve(x) = ((A**x) * Fish).to_a.flatten.sum

puts "Day 05\n",
"==================\n",
"✮: #{solve(80)}\n",
"★: #{solve(256)}"