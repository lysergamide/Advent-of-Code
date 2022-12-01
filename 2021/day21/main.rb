#!/usr/bin/env ruby
# frozen_string_literal: true

start = $<.readlines(chomp: true).map { _1.scan(/\d+/).last.to_i }

def play(start, die)
  start.map! { _1 - 1 }
  rolls = 0
  score = [0, 0]
  idx = 0
  loop do
    start[idx] += die.take(3).sum
    score[idx] += 1 + (start[idx] % 10)
    rolls += 3
    die = die.drop 3
    return score.min * rolls if score[idx] >= 1000
    idx ^= 1
  end
end

R = [1, 2, 3].product([1, 2, 3])

def dp(start)
  @cache ||= hash.new
end

Silver = play(start, (1..).lazy)
Gold = nil

puts "Day 21\n",
     "===========================\n",
     "✮: #{Silver}\n",
     "★: #{Gold}"
