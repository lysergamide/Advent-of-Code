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

def fillBasin(point, filled = Set.new)
  return 0 if filled === point
  neighbors(point).reject{ Cave[_1] > 8 || filled === _1 }
                  .select{ Cave[_1] > Cave[point] }
                  .map{ fillBasin(_1, filled << point) }
                  .sum(1)
end

Low    = Cave.keys.select{ |x| neighbors(x).all?{ Cave[x] < Cave[_1] } }
Silver = Low.sum{ Cave[_1] + 1 }
Gold   = Low.map{ fillBasin _1 }.sort[-3..].reduce(&:*)

puts "Day 09\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"