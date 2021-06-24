#!/usr/bin/env ruby 
# frozen_string_literal: true

RS, T, TS = File.read("input/16.txt").split(/.*ticket.*\n/).then do |rs, t, ts|
  rules = rs.split("\n").map {
    /(?<name>.+): (?<l1>\d+)-(?<l2>\d+) or (?<u1>\d+)-(?<u2>\d+)/ =~ _1
    [name, [(l1.to_i..l2.to_i), (u1.to_i..u2.to_i)]]
  }.to_h

  ticket = t.split(",").map(&:to_i)
  tickets = ts.split("\n").map { _1.split(",").map(&:to_i) }

  [rules, ticket, tickets]
end

def silver
  TS.flatten.select { |x|
    RS.each_value.to_a.flatten.none? { _1.cover? x }
  }.sum
end

def gold
  good = [T] + TS.select { |t| t.none? { |x| RS.each_value.to_a.flatten.none? { _1.cover? x } } }
  places = RS.map { |name, rule|
    [name,
     good[0].each_index.select { |i| good.all? { |t| rule.any? { _1.cover? t[i] } } }]
  }.to_h

  found, potential = places.select { _2.size == 1 }, places.select { _2.size > 1 }

  until potential.empty?
    potential.each_key do |k|
      found.each_value { potential[k] -= _1 }
      if potential[k].size == 1
        found[k] = potential[k]
        potential.delete k
      end
    end
  end

  found.select { |k, i| /departure/ =~ k }.map { T[_2.first] }.reduce(&:*)
end

puts("Day 16\n" \
"==================\n" \
"✮: #{silver}\n" \
"★: #{gold}")
