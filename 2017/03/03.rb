#!/usr/bin/env ruby
# frozen_string_literal: true

# input = File.read(ARGV.first).chomp

module Ord
  NORTH = 0
  EAST  = 1
  SOUTH = 2
  WEST  = 3
  MAX   = 4
end

class Grid
  MAX = 1000
  CEN = 499

  def initialize
    @grd = Array.new(@@MAX, Array.new(@@MAX, nil))
    @dir = Ord::EAST
    @pos = [@@CEN, @@CEN]

    @rel_size = 0
  end

  def move; end
end
