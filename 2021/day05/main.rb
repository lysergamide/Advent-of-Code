Pairs = gets(nil).chomp
                 .lines
                 .map{ |x| x.split(" -> ")
                            .map { Complex *_1.split(",").map(&:to_i) } }

S, G = Pairs.reduce([Hash.new(0), Hash.new(0)]) do |hashes, pair|
  hsilver, hgold = hashes
  x, y = pair
  dir  = y - x
  dir  = Complex *(dir/dir.magnitude).rectangular.map(&:round) # normalize vector

  until x == (y + dir)
    hsilver[x] += 1 unless dir.magnitude > 1
    hgold[x]   += 1

    x += dir
  end

  [hsilver, hgold]
end

def score(hash) = hash.values.count { _1 > 1 }

puts "Day 04\n",
"==================\n",
"✮: #{score(S)}\n",
"★: #{score(G)}"