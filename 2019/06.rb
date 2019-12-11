#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

class Graph
  attr_accessor :edges

  def initialize
    @edges = Hash.new { |h, k| h[k] = [] }
  end

  def [](val)
    @edges[val]
  end

  # Dijkstra's
  def path_tree(source)
    unvisited = @edges.each_key.to_set
    tree      = Hash.new { |h, k| h[k] = Float::INFINITY }

    tree[source] = 0
    until unvisited.empty?
      current = unvisited.each
                         .min_by { |v| tree[v] }

      @edges[current].each do |child|
        tree[child] = [tree[child], tree[current] + 1].min
      end
      unvisited.delete(current)
    end

    tree
  end

  def shortest_path(source, target)
    path_tree(source)[target]
  end
end

lines = File.read(ARGV.first)
            .chomp
            .lines
            .map(&:chomp)

system = Graph.new

lines.each do |line|
  parent, child = line.split(')')
  system[parent] << child
  system[child] << parent
end

puts system.path_tree('COM')
           .each_value
           .sum

puts system.shortest_path('YOU', 'SAN') - 2
