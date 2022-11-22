#!/usr/bin/env ruby
# frozen_string_literal: true

require "matrix"
require "set"
V = Vector

class Probe
  attr_accessor :pos, :overshot_x, :vel, :v0
  attr_reader :max_height

  def initialize(vel)
    @vel = @v0 = vel
    @pos = V[0, 0]
  end

  def step!
    @max_height ||= 0

    @pos += @vel
    @vel = V[[@vel[0] - 1, 0].max, @vel[1] - 1]
    @max_height = [@pos[1], @max_height].max
  end
end

class Square
  attr_reader :xmax, :ymin
  def initialize(xs, ys)
    @xs, @ys = xs, ys
    @xmax, @ymin = xs.max, ys.min
  end

  # simulated annealing
  # sadly won't help for part 2 :c
  @@KMAX = 200
  def find_highest
    max_y = -(1.0 / 0.0)

    vy = @ymin.abs / 2
    (0..@@KMAX).each do |k|
      temp = 1.0 - Math.exp((k + 1) / @@KMAX)
      next_vy = vy + rand(-vy..(@ymin.abs - vy))
      probe = vy_hits?(next_vy)
      if (probe&.max_height.to_i > max_y) || ((temp * @@KMAX) > rand(@@KMAX))
        max_y = [max_y, probe.max_height].max if probe
        vy = probe.vel[1]
      end
    end

    max_y
  end

  def brute_force
    ymax = -(1.0 / 0.0)
    distinct = Set.new
    (0..@xmax).each do |vx|
      (@ymin..-@ymin).each do |vy|
        probe = Probe.new V[vx, vy]
        if hits?(probe)
          distinct << probe.v0 if hits? probe
          ymax = [ymax, probe.max_height].max
        end
      end
    end
    [ymax, distinct.size]
  end

  def vy_hits?(vy)
    step = (@xmax / 2).floor
    vx = 0
    until step.zero?
      probe = Probe.new(V[vx + step, vy])
      return probe if hits?(probe)

      if probe.overshot_x
        step /= 2
      else
        vx += step
      end
    end

    return nil
  end

  def hits?(probe)
    until overshot?(probe)
      return true if contains?(probe)
      probe.step!
    end
    false
  end

  def overshot?(probe)
    if (probe.pos[0] > @xmax) || (probe.pos[1] < @ymin)
      probe.overshot_x = probe.pos[0] > @xmax
      return true
    end

    false
  end

  def contains?(probe)
    @xs.cover?(probe.pos[0]) && @ys.cover?(probe.pos[1])
  end
end

Silver, Gold =
  Square.new(*$<.read.scan(/-?\d+\.{2}-?\d+/).map { eval _1 }).brute_force

puts "Day 17\n",
     "============================\n",
     "✮: #{Silver}\n",
     "★: #{Gold}"
