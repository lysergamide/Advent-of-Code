# /user/bin/env ruby
# frozen_string_literal: true

Nums   = File.readlines("input", chomp: true).map(&:to_i)
Groups = Nums.each_cons(3).map(&:sum)

def solve(xs)
  xs.each_cons(2).count { _1 < _2 }
end

puts "Day 01\n",
     "==================\n",
     "✮: #{solve(Nums)}\n",
     "★: #{solve(Groups)}"