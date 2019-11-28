#!/usr/bin/env ruby

require 'set'

class Cardenal
    def initialize
        @pos = [0, 0]
    end

    def move(char)
        case char
        when '^' then @pos[1] += 1
        when 'v' then @pos[1] -= 1
        when '>' then @pos[0] += 1
        when '<' then @pos[0] -= 1
        end

        @pos.dup #need copy for set to work w/ array
    end

end

input = File.open(ARGV.first).read.chomp

visited1 = Set[[0,0]]
visited2 = Set[[0,0]]

santa   = Cardenal.new
pair    = [Cardenal.new, Cardenal.new]
turn    = true

input.each_char do |c|
    visited1 << santa.move(c)
    visited2 << pair[turn ? 1 : 0].move(c)

    turn ^= true
end

puts visited1.size
puts visited2.size