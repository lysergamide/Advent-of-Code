#!/usr/bin/env ruby
# frozen_string_literal: true

WORDS = %w[_ one two three four five six seven eight nine].each_with_index.to_h
ALL = /(?=(\d|#{WORDS.keys.join '|'}))/

input = $<.each_line.to_a

def word_value(word)
  word.gsub(Regexp.union(WORDS.keys), WORDS)
end

def solve(lines)
  lines.map { yield _1 }
       .map { "#{_1[0]}#{_1[-1]}".to_i }
       .sum
end

puts solve(input) { _1.scan(/\d/) }
puts solve(input) { _1.scan(ALL).flatten.map { |w| word_value w } }
