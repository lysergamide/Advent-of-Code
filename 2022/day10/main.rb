#!/usr/bin/env ruby
# frozen_string_literal: true

silver = cycle = 0
gold   = 6.times.map { [" "] * 40 }
x      = 1

def neighbors(idx) =
  [idx.pred, idx, idx.succ]

$<.readlines(chomp: true).map(&:split).each do |(op, val)|
    (op == "noop" ? 1 : 2).times do |subcyle|
      gold[cycle / 40][cycle % 40] = "█" if neighbors(x).any?(cycle % 40)

      cycle  += 1
      silver += x * cycle if ((cycle + 20) % 40).zero?
      x      += val.to_i  if !subcyle.zero?
    end
end

puts silver, gold.map(&:join)