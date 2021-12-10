# /user/bin/env ruby
# frozen_string_literal: true

require 'set'

I = $<.readlines(chomp: true)
      .map { _1.scan(/\d/).map(&:to_i) }

Cave = Hash.new(Float::INFINITY).tap do |cave|
  (0 ... I.size).each do |y|
    (0 ... I[0].size).each do |x|
      cave[Complex(x, y)] = I[y][x]
    end
  end
end

def neighbors(x) = [1+0i, -1+0i, 0+1i, 0-1i].map{ x + _1 }

def fillBasin(point)
  sum, stack, visited = 0, [], Set.new

  until stack.empty? 
    x = stack.pop
    next if visited === x
    neighbors(x).select{ Cave[_1] < 9 && Cave[_1] > Cave[point] }
                .each  { stack << _1 }
  end

  sum
end

Low    = Cave.keys.select{ |x| neighbors(x).all?{ Cave[x] < Cave[_1] } }
Silver = Low.sum{ Cave[_1] + 1 }
Gold   = Low.map{ fillBasin _1 }.max(3).reduce(&:*)

puts "Day 09\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"