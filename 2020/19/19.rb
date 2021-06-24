#!/usr/bin/env ruby
# frozen_string_literal: true
require "pp"

R, S = File.read("input/19.txt")
           .split("\n\n")
           .map { _1.split("\n") }
           .then { |rs, strs| [rs.map { _1.split(":").map(&:strip) }.to_h.freeze, strs.freeze] }

def solve(part2 = false)
  rules = R.to_a.map { [_1.dup, _2.dup] }.to_h
  if part2
    rules["8"] = "42+".dup
    rules["11"] = "42@ 31@".dup
  end

  dfs = ->(r) do
    case rules[r]
    when /\|/
      rules[r].split("|").select { /\d+/ =~ _1 }.each do |group|
        rules[r].gsub!(group, "(#{group.split.map { dfs.(_1) }.join})")
      end
      rules[r] = "(" + rules[r] + ")"
    when /\d+/
      ds = rules[r].scan(/\d+/)
      ds.each { rules[r].gsub!(_1, dfs.(_1)) }
    else
      rules[r].gsub!(/"(\w+)"/, '\1')
    end

    rules[r].tr!(" ", "")
    rules[r]
  end
  dfs.call("0")
end

silver = S.count { /^#{solve()}$/ =~ _1 }
gold = S.count do |str|
  re = solve(true)
  (1...str.size / 2).any? { /^#{re.gsub("@", "{#{_1}}")}$/ =~ str } # just brute force it lul
end

puts("Day 19\n" \
"==================\n" \
"✮: #{silver}\n" \
"★: #{gold}")
