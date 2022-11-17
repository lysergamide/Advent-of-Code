#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

ORDS = [[1, 0], [-1, 0], [0, 1], [0, -1]].map{ Vector[*_1] }.freeze

class Map
  attr_reader :max

  def initialize(data)
    @data = data
    @max  = Vector[data[0].size, data.size]
  end

  def [](pos)
    pairs = pos.to_a.zip(@max.to_a)
    x, y  = pairs.map{ _1 % _2 }
    ret   = @data[x][y] + pairs.sum{ (_1 / _2).floor }

    ret > 9 ? ret % 10 + 1 : ret
  end

  def n4(p)
    ORDS.map{ _1 + p }
        .select{ |n| (n[0] >= 0) && (n[1] >= 0) }
  end


  def bfs(last = @max - Vector[1, 1])
    first = Vector[0, 0]

    val   = [[first, 0]].to_h
    queue = [first]

    until queue.empty?
      node = queue.shift
      next if node.zip(last).any?{ _1 > _2 }

      n4(node).each do |child|
        new_val = self[child] + val[node]

        if !val.include?(child) || (new_val < val[child])
          val[child] = new_val
          queue << child
        end
      end
    end

    return val[last]
  end
end


@cave_map = Map.new(
  $<.readlines(chomp: true).map do |line|
    line.chomp.chars.map &:to_i
  end.transpose
)

puts "Day 15\n",
"==================\n",
"✮: #{@cave_map.bfs}\n",
"★: #{@cave_map.bfs(@cave_map.max * 5 - Vector[1, 1])}"