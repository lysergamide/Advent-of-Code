#!/usr/bin/env ruby
# frozen_string_literal: true

lines = File.readlines(ARGV.first)
            .map(&:to_i)

def p1(num)
  num / 3 - 2
end

def p2(num)
  ret = 0

  num = p1(num)
  until num <= 0
    ret += num
    num = p1(num)
  end

  ret
end

puts(
  "Day 01\n"                     \
  "--------\n"                   \
  "#{lines.sum { |x| p1(x) }}\n" \
  "#{lines.sum { |x| p2(x) }}"
)
