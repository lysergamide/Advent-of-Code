#!/usr/bin/env ruby -w
# frozen_string_literal: true

I = File.readlines("input/21.txt").map do |line|
  /(?<foods>.*) \(contains (?<allerg>.+)\)/ =~ line
  [allerg.split(", "), foods.split]
end
A = I.map(&:first).reduce(:|)

#p1
potential = A.map { |alg|
  [alg, I.select { |fst, | fst.include? alg }.map(&:last).reduce(:&)]
}.to_h

silver = (I.map(&:last).flatten - potential.each_value.to_a.flatten).size

#p2
bad = Hash.new.tap do |h|
  until potential.empty?
    potential.select { _2.size == 1 }.each do |alg, ing|
      h[alg] = ing
      potential.each_key { potential[_1] -= h[alg] }.delete alg
    end
  end
end

gold = bad.sort.map(&:last).join(",")

puts("Day 20\n" \
"==================\n" \
"✮: #{silver}\n" \
"★: #{gold}")
