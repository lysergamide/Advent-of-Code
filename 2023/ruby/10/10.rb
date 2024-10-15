#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

NORTH = Vector[-1, 0]
EAST = Vector[0, 1]
SOUTH = Vector[1, 0]
WEST = Vector[0, -1]

class Pipe
  CONNECTIONS = {
    '|' => [NORTH, SOUTH],
    '-' => [EAST, WEST],
    'L' => [NORTH, EAST],
    'J' => [NORTH, WEST],
    '7' => [SOUTH, WEST],
    'F' => [SOUTH, EAST],
    '.' => [],
    'S' => [NORTH, EAST, SOUTH, WEST]
  }.freeze

  attr_reader :pos, :str, :connections

  def initialize(pipe_char, pos)
    @pos = pos
    @str = pipe_char
    @connections = CONNECTIONS[pipe_char].map { pos + _1 }
  end

  def connected?(other_pipe)
    @connections.include?(other_pipe.pos) && other_pipe.connections.include?(@pos)
  end
end

class PipeMaze
  def path
    return @path if @path

    @path ||= []
    ancestor = {}

    recur = lambda do |pipe|
      return if ancestor.include? pipe

      pipe.connections.select { pipe.connected? @pipes[_1] }.map(&@pipes).each do |next_pipe|
        ancestor[next_pipe] = pipe
        recur.call next_pipe
      end
    end

    recur.call @start
    start = @start
    until ancestor[start].nil?
      @path << start
      start = ancestor[start]
    end
    p ancestor.keys.map(&:pos)

    @path
  end

  def [](pos) = @pipes[pos]

  def <<(pipe)
    @pipes ||= {}
    @start = pipe if pipe.str == 'S'

    @pipes[pipe.pos] = pipe
  end
end

pipe_maze = PipeMaze.new

$<.readlines(chomp: true).each_with_index do |line, y|
  line.chars.each_with_index do |chr, x|
    next if /\.|\s+/ =~ chr

    pipe_maze << Pipe.new(chr, Vector[y, x])
  end
end

puts(pipe_maze.path.size / 2)
