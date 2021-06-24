#!/usr/bin/env ruby
# frozen_string_literal: true

require "pp"

class Material
  attr_accessor :name, :min_build, :mats

  def initialize(str)
    /^(?<mats>.*) => (?<min_build>\d+) (?<name>\w+)/ =~ str
    @name = name
    @min_build = min_build.to_i
    @mats = mats.split(",")
      .map { |mat| mat.strip.split.then { |x| [x[0].to_i, x[1]] } }
  end
end

lines = File.open("input/14.txt").readlines.map { |l| l.chomp }
mat_graph = {}

lines.each do |line|
  m = Material.new(line)
  mat_graph[m.name] = m.mats
end

#part 1
need = {}
stack = [[1, "FUEL"]]
while stack
  quant, name = stack.pop
  mats = mat_graph[name].mats.map { |x| x[0] * quant }
end

pp mat_graph
