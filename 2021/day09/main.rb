require 'set'

N = [Complex(1,0), Complex(-1,0), Complex(0,1), Complex(0,-1)]
I = $<.read.strip.lines.map { _1.scan(/\d/).map(&:to_i) }

L = I.each_index
     .to_a
     .product(I[0].each_index.to_a)
     .reduce(Hash.new(Float::INFINITY)) do |h, pos|
        h[Complex(*pos)] = I[pos[0]][pos[1]]
        h
     end

Low = L.keys.select { |pos| N.all?{ L[_1 + pos] > L[pos] } }
p Low.map { L[_1] + 1 }.sum

basins  = []
#flooded = Set.new

Low.each do |point|
#  next if flooded.include? point
  stack = [point]
  basins << 0
  color = Set.new
  lel = []
  until stack.empty?
    x = stack.pop
    color << x
    lel << x
#    flooded << x
    basins[-1] += 1
    N.map { _1 + x }
     .reject {  L[_1] > 8 || color.include?(_1) }
     .select { L[_1] > L[x] }
     .each { stack << _1; color << _1 }
  end
  p lel.map {L[_1]}.sort
end

p basins.sort[-3..].reduce :*