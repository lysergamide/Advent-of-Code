#!/usr/bin/env ruby
# frozen_string_literal: true

def ord?(left, right)
  if Integer === left && Integer === right
    left <=> right
  elsif Array === left && Array === right
    return  0 if [left, right].all?(&:empty?)
    return -1 if left.empty?
    return  1 if right.empty?

    if (ord = ord?(left.first, right.first)).zero?
      ord?(left.drop(1), right.drop(1))
    else
      ord
    end
  elsif Array === left && Integer === right
    ord?(left, [right])
  else
    ord?([left], right)
  end
end

P = $<.readlines(chomp: true)
      .reject(&:empty?)
      .map{ |arr| eval arr }

puts P.each_slice(2)
      .with_index
      .select { |pair, _| ord?(*pair) == -1 }
      .map    { |_,  idx| idx.succ }
      .sum

puts ([[[2]], [[6]]] + P)
        .sort   { |a, b| ord?(a, b) }
        .each_with_index
        .select { |x,   _| x == [[2]] || x == [[6]]}
        .map    { |_, idx| idx.succ }
        .reduce &:*