Nums = $<.read.scan(/\d+/).map(&:to_i)

def solve(&block)
  (0..Nums.max).map do |i|
    Nums.map { block[(i - _1).abs] }.sum
  end.min
end

puts "Day 05\n",
"==================\n",
"✮: #{solve(&:itself)}\n",
"★: #{solve{ |x| (x*(x+1)/2) }}"