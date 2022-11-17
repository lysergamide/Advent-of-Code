#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

Network = $<.readlines(chomp: true).reduce(Hash.new{ _1[_2] = Set.new }) do |h, line|
  a, b = line.split('-')
  h[a] << b if !(b == "start")
  h[b] << a if !(a == "start")
  h
end

def dfs(node, seen = Set.new, backtrack: false)
  return 1 if node == "end"

  seen << node if /[a-z]+/ =~ node
  visited, unvisited = Network[node].partition{ seen.include? _1 }

  sum  = unvisited.sum{ dfs(_1, seen.dup, backtrack: backtrack) }
  sum += visited.sum{ dfs(_1, seen.dup, backtrack: false) } if backtrack

  return sum
end

Silver = dfs("start")
Gold   = dfs("start", backtrack: true)

puts "Day 12\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"