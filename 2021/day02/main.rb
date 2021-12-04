# /user/bin/env ruby
# frozen_string_literal: true

I = File.read("input")
        .scan(/(\w+) (\d+)/)
        .map do |w, x|
                case w
                when "forward" then x.to_i
                when "down"    then Complex(0, x.to_i)
                when "up"      then Complex(0, -x.to_i)
                end
        end

def prod(x) = x.rectangular.reduce(:*)

silver, gold = I.reduce([0, 0]) do |sum, x|
 sum = [sum[0] + x,
        sum[1] + x.real * Complex(1, sum[0].imag)]
end

puts "Day 02\n",
"==================\n",
"✮: #{prod(silver)}\n",
"★: #{prod(gold)}"