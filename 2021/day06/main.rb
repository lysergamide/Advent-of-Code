I  = gets(nil).chomp
              .scan(/\d+/)
              .map(&:to_i)
              .tally.tap { _1.default = 0 }

def step(fish)
  Hash.new(0).tap do |f|
    (0..7).each{ f[_1] += fish[_1 + 1] }
    f[8]  = fish[0]
    f[6] += fish[0]
  end
end

sfish = 80.times.reduce(I) { step _1 }
gfish = (256 - 80).times.reduce(sfish) { step _1 }

Silver, Gold  = [sfish, gfish].map { _1.values.sum } 

puts "Day 05\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"