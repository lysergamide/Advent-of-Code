#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

L = ("a".."z").to_a
BAD = "i o l".split.map { _1.ord - "a".ord }.to_set

def good(pw)
  return false unless pw.each_cons(3).any? { |x| x.each_cons(2).all? { _1 + 1 == _2 } }
  return false if pw.any? { BAD.include? _1 }

  /(.)\1.*([^\1])(\2)/ =~ pw.map { L[_1] }.join
end

def generate(start)
  pw = start.chars.map { _1.ord - "a".ord }

  loop do
    i = pw.size - 1

    carry = true
    until !carry
      pw[i] += 1
      carry = pw[i] >= L.size
      pw[i] %= L.size
      i -= 1
    end

    return pw.map { L[_1] }.join if good(pw)
  end
end

silver = generate(File.read("input/11.txt").strip)
gold = generate(silver)

puts("
 Day 11
============
✮: #{silver}
★: #{gold}")
