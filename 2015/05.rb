#!/usr/bin/env ruby
# frozen_string_literal: true
require 'set'

def nice(str)
  vowels = Set.new(['a','e','i','o','u',])
  bad    = ['ab','cd','pq','xy']

  return false if bad.any? { |b| str.include? b }

  count = str.chars.count { |c| vowels.member? c }
  return count > 2 && str =~ /(.)\1/ # matches a repeating character
end

# gotta love regex
# first matches a pair of letters that appears twice
# second matches a letters that repeats with one letter in between
def nice2(str)
  return str =~ /(..).*\1/ && str =~ /(.).\1/
end

input  = File.readlines('input/05.txt').map &:chomp
silver = input.count { |x| nice  x }
gold   = input.count { |x| nice2 x }

puts(
  "Day 05\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
