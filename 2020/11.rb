#!/usr/bin/env ruby 
# frozen_string_literal: true

class Array
  def plus(x)
    zip(x).map(&:sum)
  end
end

DIRS = [-1, 1, 0].product([-1, 1, 0]) - [[0, 0]]

def update(g, limit)
  inbounds = ->(y, x) { y >= 0 && y < g.size && x >= 0 && x < g[0].size }

  part1 = ->(pos) { DIRS.count { y, x = pos.plus(_1); inbounds.(y, x) && g[y][x] == "#" } }

  part2 = ->(pos) do
    DIRS.count do |dir|
      y, x = pos
      loop do
        y, x = [y, x].plus dir
        break unless inbounds.(y, x) && g[y][x] == "."
      end
      inbounds.(y, x) && g[y][x] == "#"
    end
  end

  neighbors = case limit
    when 4 then part1
    when 5 then part2
    end

  g.map.with_index do |row, y|
    row.map.with_index do |spot, x|
      ns = neighbors.([y, x])

      if spot == "L" && ns == 0
        "#"
      elsif spot == "#" && ns >= limit
        "L"
      else
        spot
      end
    end
  end
end

I = File.readlines("input/11.txt").map { _1.chomp.chars }

silver, gold = [4, 5].map { |n|
  g = I
  loop do
    last, g = g, update(g, n)
    break if last == g
  end
  g.flatten.count("#")
}


puts(
  "Day 11\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)


