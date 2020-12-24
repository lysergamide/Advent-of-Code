#!/usr/bin/env ruby -w
# frozen_string_literal: true
require "set"

p1, p2 = File.read("input/22.txt").split("\n\n").map { _1.split("\n")[1..].map(&:to_i) }

def score(deck)
  deck.reverse.each_with_index.sum { _1 * _2.succ }
end

def combat(p1, p2)
  until [p1, p2].any? &:empty?
    if p1.first > p2.first
      p1 << p1.shift << p2.shift
    else
      p2 << p2.shift << p1.shift
    end
  end

  score([p1, p2].find &:any?)
end

def recombat(p1, p2)
  seen = Set.new
  until [p1, p2].any? &:empty?
    return [true, score(p1)] if seen.include? [p1, p2]

    if (p1.size > p1[0]) && (p2.size > p2[0])
      p1_win, = recombat(p1[1..p1[0]], p2[1..p2[0]])
    else
      p1_win = p1.first > p2.first
    end

    seen << [p1.dup, p2.dup]

    if p1_win
      p1 << p1.shift << p2.shift
    else
      p2 << p2.shift << p1.shift
    end
  end

  win = [p1, p2].max_by &:size
  [win == p1, score(win)]
end

puts("Day 22\n" \
"==================\n" \
"✮: #{combat(p1.dup, p2.dup)}\n" \
"★: #{recombat(p1.dup, p2.dup).last}")
