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

    silver = 0
    gold   = 0

    (lower..upper).each do |num|
      part1, part2 = num.pwd?
      silver += part1 ? 1 : 0
      gold   += part2 ? 1 : 0
    end

    [silver, gold]
  end
end

silver, gold = File.read(ARGV.first)
                   .chomp
                   .find_pwds

puts(
  "Day 04\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)