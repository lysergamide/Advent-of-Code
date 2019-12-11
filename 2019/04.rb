#!/usr/bin/env ruby
# frozen_string_literal: true

class Integer
  def pwd?
    nums = to_s.chars.to_a
    return [false, false] if nums != nums.sort

    count = Hash.new(0).tap { |h| nums.each { |x| h[x] += 1 } }

    [count.values.any? { |x| x > 1 },
     count.value?(2)]
  end
end

class String
  def find_pwds
    lower, upper = split('-').map(&:to_i)

    part1 = 0
    part2 = 0

    (lower..upper).each do |num|
      res = num.pwd?
      part1 += res[0] ? 1 : 0
      part2 += res[1] ? 1 : 0
    end

    [part1, part2]
  end
end

puts 'Day 04:'
puts File.read(ARGV.first)
         .chomp
         .find_pwds
