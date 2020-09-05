#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

graph  = Hash.new { |h, k| h[k] = Hash.new }
places = Set.new
min    = Float::INFINITY
max    = 0

File.open("./input/09.txt").each_line do |line|
  /(?<l0>\w+) to (?<l1>\w+) = (?<d>\d+)/ =~ line
  graph[l0][l1] = d.to_i
  graph[l1][l0] = d.to_i
  places << l0
  places << l1
end

places.to_a.permutation.each do |path|
  tmp = 0
  (0...path.length - 1).each do |i|
    dist = graph[path[i]][path[i + 1]]
    tmp += dist
  end
  min = [min, tmp].min
  max = [max, tmp].max
end

puts("
Day 09
======
✮: #{min}
★: #{max}")
