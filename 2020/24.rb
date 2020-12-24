#!/usr/bin/env ruby -w
# frozen_string_literal: true

ORDS = {
  "e" => [1, 1, 0],
  "se" => [1, 0, -1],
  "sw" => [0, -1, -1],
  "w" => [-1, -1, 0],
  "nw" => [-1, 0, 1],
  "ne" => [0, 1, 1],
}.freeze

def add(a, b) a.zip(b).map(&:sum) end
def sum(w) w.each_value.count &:itself end

I = File.readlines("input/24.txt")
        .map { |line| line.scan(/e|se|sw|w|nw|ne/).map { ORDS[_1] } }

silver = sum(
  world = Hash.new { |h, k| h[k] = false }.tap do |h|
    I.map { |arr| arr.reduce { add(_1, _2) } }
     .each { h[_1] = !h[_1] }
  end
)

100.times do
  count = Hash.new { |h, k| h[k] = 0 }

  world.each_key.filter { world[_1] }.each do |pos|
    ORDS.each_value
        .map { add(_1, pos) }
        .each { world[_1]; count[_1] += 1 }
  end

  world.each_key do |k|
    case count[k]
    when 2 then world[k] = true
    when 1 then next
    else world[k] = false
    end
  end
end

puts("Day 24\n" \
"==================\n" \
"✮: #{silver}\n" \
"★: #{sum(world)}")
