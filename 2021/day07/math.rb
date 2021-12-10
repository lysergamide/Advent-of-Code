# /user/bin/env ruby
# frozen_string_literal: true

Nums = $<.read.scan(/\d+/).map(&:to_i).sort

def solve(x, &block) = Nums.map{ block[(x - _1).abs] }.sum
def mean(xs)   = xs.sum / xs.size
def median(xs) = xs[xs.size / 2]

puts "Day 07\n",
"==================\n",
"✮: #{solve(median(Nums), &:itself)}\n",
"★: #{solve(mean(Nums)){ |x| x*(x+1)/2 }}"