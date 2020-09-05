#!/usr/bin/env ruby
# frozen_string_literal: true

inst = []

File.readlines("./input/06.txt").each do |line|
  op = line[/(^toggle|^turn \w+)/]

  start, stop =
    line.scan(/\d+,\d+/)
        .map { |x| x.split(",").map(&:to_i) }

  inst << [op, start, stop]
end

def part1(inst)
  lights = Array.new(1000) { Array.new(1000) { 0 } }

  inst.each do |op, start, stop|
    lop = case op
      when "turn on"  then ->(x) { 1 }
      when "turn off" then ->(x) { 0 }
      when "toggle"   then ->(x) { 1 ^ x }
      end

    (start.first..stop.first).each do |y|
      (start.last..stop.last).each do |x|
        lights[y][x] = lop.(lights[y][x])
      end
    end
  end

  lights.sum &:sum
end

def part2(inst)
  lights = Array.new(1000) { Array.new(1000) { 0 } }

  inst.each do |op, start, stop|
    lop = case op
      when "turn on"  then ->(x) { x += 1 }
      when "turn off" then ->(x) { x -= 1 }
      when "toggle"   then ->(x) { x += 2 }
      end

    (start.first..stop.first).each do |y|
      (start.last..stop.last).each do |x|
        lights[y][x] = lop.(lights[y][x])
      end
    end
  end

  lights.sum &:sum
end

silver = part1(inst)
gold   = part2(inst)

puts(
  "Day 06\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
