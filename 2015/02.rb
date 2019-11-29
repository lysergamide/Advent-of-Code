#!/usr/bin/env ruby
# frozen_string_literal: true

lines = File.open(ARGV.first).readlines
boxs = lines.map { |line| line.split("x").map(&:to_i) }
surfs = boxs.map { |box| box.combination(2) }

paper = surfs.map do |surfaces|
  areas = surfaces.map { |s| s.inject(:*) }
  areas.sum * 2 + areas.min
end.sum

ribbon = boxs.map do |box|
  box.sort.take(2).sum * 2 + box.inject(:*)
end.sum

puts paper
puts ribbon
