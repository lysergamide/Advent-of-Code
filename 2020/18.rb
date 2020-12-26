#!/usr/bin/env ruby 
# frozen_string_literal: true

I = File.readlines("input/18.txt")

O = {
  "+" => ->(a, b) { (a + b).to_s },
  "*" => ->(a, b) { (a * b).to_s },
}.freeze

# dudge regex lmao
def solve(line, p2 = false)
  while /(?<outer>\((?<inner>[^()]*)\))/ =~ line
    line.sub!(outer, solve(inner, p2))
  end

  if p2
    while /(?<outer>(?<a>\d+) (?<o>\+) (?<b>\d+))/ =~ line
      line.sub!(outer, O[o].call(a.to_i, b.to_i))
    end

    while /(?<outer>(?<a>\d+) (?<o>\*) (?<b>\d+))/ =~ line
      line.sub!(outer, O[o].call(a.to_i, b.to_i))
    end
  else
    while /(?<outer>(?<a>\d+) (?<o>\+|\*) (?<b>\d+))/ =~ line
      line.sub!(outer, O[o].call(a.to_i, b.to_i))
    end
  end

  line
end

puts("Day 18\n" \
"==================\n" \
"✮: #{I.sum { solve(_1.clone).to_i }}\n" \
"★: #{I.sum { solve(_1, true).to_i }}")
