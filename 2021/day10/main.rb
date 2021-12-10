# /user/bin/env ruby
# frozen_string_literal: true

SScore  = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }
GScore  = { "(" => 1, "[" => 2,  "{" => 3,    "<" => 4 }
Corrupt = Regexp.union(SScore.keys)
Pairs   = /(\(\)|\[\]|\{\}|<>)/

I = $<.readlines(chomp: true)
      .map { while _1.gsub!(Pairs, ""); end; _1 }

Silver = I.sum { SScore[_1[Corrupt]] || 0 }
Gold   = I.reject { Corrupt =~ _1 }
          .map{ |line| line.reverse
                           .chars
                           .reduce(0){ |sum, x| sum * 5 + GScore[x] } } 
          .sort
          .then{ _1[_1.size/2] }

puts "Day 10\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"