#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

T, RS = $<.read.chomp.split("\n\n").then{ |t, r| [t, r.split("\n").map{ _1.split /\s+->\s+/ }.to_h] }
Keys = RS.keys.to_set

def step(state)
  next_state = Hash.new 0

  state.each_key do |pair|
    next_state[pair[0] + RS[pair]] += state[pair]
    next_state[RS[pair] + pair[1]] += state[pair]
  end

  next_state
end

def delta(state)
  Keys.join.chars.uniq.map do |char|
    state.keys.select{ _1[0] == char }.sum(&state)
  end.minmax.reduce{ _2 - _1 } + 1
end

Init  = T.chars.each_cons(2).map(&:join).reduce(Hash.new(0)){ |h, k| h[k] += 1; h }
Steps = Enumerator.new{ |x| i = INIT; loop{ i = step(i); x << i } }.lazy

Silver = Steps.drop(9)
Gold   = Silver.drop(30)

puts "Day 14\n",
"==================\n",
"✮: #{delta Silver.first}\n",
"★: #{delta Gold.first}"