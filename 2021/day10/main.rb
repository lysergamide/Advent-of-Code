# /user/bin/env ruby
# frozen_string_literal: true

SScore = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }
GScore = { "(" => 1, "[" => 2, "{" => 3, "<" => 4 }

I = $<.readlines(chomp: true).map { while _1.gsub!(/(\(\)|\[\]|{}|<>)/, ""); end; _1 }

Silver = I.sum do |line|
  line.tr("#{GScore.keys.join}", "").chars.first.then{ SScore[_1] || 0 }
end

Gold = I.map do |line|
  next nil if Regexp.union(SScore.keys) =~ line
  line.reverse.chars.reduce(0) { |sum, x| sum * 5 + GScore[x] }
end.compact.sort.then{ _1[_1.size/2] }

puts "Day 10\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"