#!/usr/bin/env ruby

nums = File.readlines(ARGV.first).map &:to_i

def p1(x)
  x / 3 - 2
end

def p2(x)
  ret = 0

  x = p1(x)
  until x <= 0
    ret += x
    x = p1(x)
  end

  ret
end

puts nums.map{ |x| p1 x }.sum
puts nums.map{ |x| p2 x }.sum

#       -------Part 1--------   -------Part 2--------
# Day       Time  Rank  Score       Time  Rank  Score
#   1   00:01:59   238      0   00:07:40   414      0