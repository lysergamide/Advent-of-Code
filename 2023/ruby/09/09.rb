#!/usr/bin/env ruby
# frozen_string_literal: true

class Pascal
  def initialize(grid)
    @len = grid.first.size
    @grid = [grid]

    until grid.all?(&:zero?)
      grid = grid.each_cons(2).map { (_2 - _1) }
      @grid << grid
    end
  end

  def silver
    @grid.map(&:last).reverse.reduce :+
  end

  def gold
    @grid.map(&:first).reverse.reduce { _2 - _1 }
  end
end

tris = $<.read.strip.split(/\n/).map { Pascal.new _1.scan(/-?\d+/).map(&:to_i) }
puts tris.map(&:silver).sum
puts tris.map(&:gold).sum
