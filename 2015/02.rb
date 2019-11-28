#!/usr/bin/env ruby

lines = File.open(ARGV.first).readlines

boxs  = lines.map { |line| line.split("x").map(&:to_i) }
surfs = boxs.map{ |box| box.combination(2) }

paper = surfs.map{ |surfaces| 
    areas = surfaces.map{ |s| s.inject(:*) }
    areas.sum * 2 + areas.min
}.sum

ribbon = boxs.map{ |box|
    box.sort.take(2).sum * 2 + box.inject(:*)
}.sum

puts paper 
puts ribbon