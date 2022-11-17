#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

class Octopus
  attr_reader :pos
  attr_accessor :energy

  def initialize(pos, energy)
    @pos = pos
    @energy = energy
  end

  def inc!     = @energy += 1
  def excited? = @energy > 9
end

class OctoMap
  @@ORDS = ([-1, 0, 1].product([-1, 0, 1] - [[0, 0]])).map{ Complex(*_1) }.freeze

  def initialize(data)
    @octo_data = data
  end

  def octopi = @octo_data.values

  def neighbors(o)
    @cache ||= Hash.new 

    if !@cache.include? o
      near = @@ORDS.map{ _1 + o.pos }.select{ |pos| pos.rect.all?{ (0..9).cover? _1 } }
      @cache[o] = near.map{ @octo_data[*_1] }
    end

    return @cache[o]
  end

  def step!
    flashed   = 0
    exhausted = Set.new
    excited   = octopi.tap{ _1.each &:inc! }.select(&:excited?)

    until excited.empty?
      exhausted |= excited.to_set
      flashed   += excited.size

      excited.each do |eo|
        neighbors(eo).reject{ exhausted === _1 }.each &:inc!
        eo.energy = 0
      end

      excited = octopi.reject{ exhausted === _1 || !_1.excited? }
    end

    flashed
  end

end

octoMap = OctoMap.new(
  $<.read.strip.lines.flat_map.with_index do |line, y|
    line.strip.chars.map.with_index do |i, x|
      pos = Complex(x, y)
      [pos, Octopus.new(pos, i.to_i)]
    end
  end.to_h
)

Silver = 100.times.sum{ octoMap.step! }
Gold   = (101..).lazy.drop_while{ octoMap.step! != octoMap.octopi.size }.first

puts "Day 11\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"