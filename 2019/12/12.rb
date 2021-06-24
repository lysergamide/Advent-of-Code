#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

class Planet
  attr_accessor :pos, :vel
  def initialize(x, y, z)
    @pos = [x, y, z]
    @vel = [0,0,0]
  end

  def move
    @pos = @pos.zip(@vel).map(&:sum)
  end

  def apply_grav(planet)
    d_vel = @pos.zip(planet.pos).map { |a, b| -(a <=> b) }
    @vel  = @vel.zip(d_vel).map(&:sum)
  end

  def e_total
    @vel.sum(&:abs) * @pos.sum(&:abs)
  end
end

def cycle(planets)
  planets.each do |planet|
    others = planets - [planet]
    others.map { |p| planet.apply_grav(p) }
  end
  planets.each(&:move)
end

def find_rep(planets)
  tracker = [Set.new, Set.new, Set.new]
  cycles  = [nil, nil, nil]

  step = 0
  until cycles.none?(&:nil?)
    (0 .. 2).each do |i|
      next if !cycles[i].nil?

      axis = planets.map { |p| [p.pos[i], p.vel[i]] }
      if tracker[i].include? axis
        cycles[i] = step
      else
        tracker[i] << axis
      end
    end
    cycle(planets)
    step += 1
  end

  cycles.reduce(1, :lcm)
end

coords = File.readlines(ARGV.first)
             .map { |line| line.scan(/-?\d+/).map(&:to_i) }

planets1 = coords.map{ |c| Planet.new(*c) }
planets2 = coords.map{ |c| Planet.new(*c) }

1000.times { cycle(planets1) }

silver = planets1.sum(&:e_total)
gold   = find_rep(planets2)

puts(
  "Day 12\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)