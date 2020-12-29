#!/usr/bin/env ruby
# frozen_string_literal: true

boxes = File.open(ARGV.first)
            .readlines
            .map { |line| line.split("x").map(&:to_i) }

surfs = boxes.map { |box| box.combination(2) }

paper = surfs.sum do |surfaces|
  areas = surfaces.map { |s| s.inject(:*) }
  ret
end

ribbon = boxes.sum do |box|
  box.sort.take(2).sum * 2 + box.inject(:*)
end

puts "Day 02
------
Silver: #{paper}
Gold:   #{ribbon}
"
