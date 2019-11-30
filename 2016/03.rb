#!/usr/bin/env ruby

class Array
  def is_tri?
    a, b, c = self.sort
    a + b > c
  end
end

lines = File.open(ARGV.first)
            .readlines
            .map(&:chomp)

nums = lines.map { |l| l.split(" ").map(&:to_i) }

puts nums.count(&:is_tri?)

puts (0..nums[0].size - 1).sum { |col|
  c_nums = nums.collect { |n| n[col] }.each_slice(3)
  c_nums.count(&:is_tri?)
}