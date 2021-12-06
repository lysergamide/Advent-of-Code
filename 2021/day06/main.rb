# /user/bin/env ruby
# frozen_string_literal: true

I  = gets(nil).chomp
              .scan(/\d+/)
              .map(&:to_i)
              .reduce(Array.new(9, 0)) { _1[_2] += 1; _1 }

def step(fish)
  Array.new(9, 0).tap do |f|
    (0..7).each{ f[_1] += fish[_1 + 1] }
    f[8]  = fish[0]
    f[6] += fish[0]
  end
end

Silver = 80.times.reduce(I) { step _1 }
Gold   = (256 - 80).times.reduce(Silver) { step _1 }

puts "Day 05\n",
"==================\n",
"✮: #{Silver.sum}\n",
"★: #{Gold.sum}"