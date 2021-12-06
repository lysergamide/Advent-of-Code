Pairs = gets(nil).lines.map do |line|
  line.scan(/\d+/).each_slice(2).map { Complex *_1 } 
end

Plane = Pairs.reduce(Hash.new(Complex(0))) do |plane, pair|
  x, y = pair
  dir  = y - x
  dir  = Complex *(dir/dir.magnitude).rectangular.map(&:round)
  step = dir.magnitude == 1 ? Complex(1) : Complex(0, 1)

  until x == y + dir
    plane[x] += step
    x        += dir
  end

  plane
end

def overlap(&block) = Plane.values.count { block[_1] > 1 }

puts "Day 05\n",
"==================\n",
"✮: #{overlap &:real}\n",
"★: #{overlap &:magnitude}"