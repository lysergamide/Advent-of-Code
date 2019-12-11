#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

NORTH = 0
EAST  = 1
SOUTH = 2
WEST  = 3
MAX   = 4

class Walker
  attr_accessor :pos, :dir, :hq

  def initialize
    @dir     = NORTH
    @pos     = [0, 0]
    @visited = Set.new
    @hq      = nil
  end

  def move(ins)
    @dir += ins[0] == 'R' ? 1 : -1
    @dir %= MAX

    mag = ins[1..-1].to_i

    # brute force lol
    mag.times do
      case dir
      when NORTH then @pos[0] += 1
      when EAST then @pos[1] += 1
      when SOUTH then @pos[0] -= 1
      when WEST then @pos[1] -= 1
      end
      if @hq.nil?
        if @visited.include? @pos
          @hq = @pos.dup
        else
          @visited << @pos.dup
        end
      end
    end
  end
end

input  = File.open(ARGV.first).read.chomp
walker = Walker.new

input.split(', ').each do |ins|
  walker.move ins
end

puts walker.pos.sum(&:abs)
puts walker.hq.sum(&:abs)
