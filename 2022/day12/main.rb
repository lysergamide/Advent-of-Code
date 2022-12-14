#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

Dirs   = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
Vals   = Matrix[ *$<.readlines(chomp: true).map { _1.chars.map(&:ord) } ]

Goal   = Vals.index("E".ord)
Silver = Vals.index("S".ord)
Gold   = [Silver] + Vals.each_with_index
                        .select { _1[0] == "a".ord }
                        .map    { _1.drop 1 }

def elevation(pos)
  return nil if pos.any?(&:negative?)   ||
                pos[0] >= Vals.row_size ||
                pos[1] >= Vals.column_size

  case (ret = Vals[*pos])
  when "S".ord then "a".ord
  when "E".ord then "z".ord
  else ret
  end
end

def neighbors(pos)
  Dirs.map    { pos.zip(_1).map(&:sum) }
      .select { (v = elevation(_1)) && elevation(pos).pred <= v }
end

def bfs(start)
  dist = {start => 0}
  q    = [start]

  until q.empty?
    pos   = q.shift
    steps = dist[pos].succ

    neighbors(pos).each do |neighbor|
      next unless !dist.include?(neighbor) || dist[neighbor] > steps

      dist[neighbor] = steps
      q << neighbor
    end
  end

  dist
end

Dist = bfs(Goal)

puts Dist[Silver], Gold.map(&Dist).compact.min