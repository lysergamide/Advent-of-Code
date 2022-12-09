#!/usr/bin/env ruby
# frozen_string_literal: true

I, L = $<.readlines("\n\n", chomp: true)

silver = I.lines(chomp: true)
          .map(&:chars)
          .transpose
          .map(&:reverse)
          .select { /\d+/ =~ _1.first }
          .map { |ln| ln[1..].reject { /\s+/ =~ _1 } }

gold = silver.map(&:dup)

moves = L.lines(chomp: true)
         .map { |ln| ln.scan(/\d+/).map(&:to_i).then { [_1, _2 - 1, _3 - 1] } }

moves.each do |n, from, to|
  n.times { silver[to] << silver[from].pop }
  gold[to] += gold[from][-n..]
  gold[from] = gold[from][...-n]
end

puts "Day 05\n",
     "============================\n",
     "✮: #{silver.map(&:last).join}\n",
     "★: #{gold.map(&:last).join}"
