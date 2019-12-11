#!/usr/bin/env ruby
# frozen_string_literal: true

class Array
  def tri?
    a, b, c = sort
    a + b > c
  end
end

nums = File.open(ARGV.first)
           .chomp
           .lines
           .map { |l| l.split(' ').map(&:to_i) }

puts nums.count(&:tri?)

puts (0..nums[0].size - 1).sum do |col|
  nums.collect { |n| n[col] }
      .each_slice(3)
      .count(&:tri?)
end
