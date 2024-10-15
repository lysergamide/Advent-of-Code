#!/usr/bin/env ruby
# frozen_string_literal: true

COLORS_RE = %(red green blue).split.map { /\d+ #{_1}/ }
SILVER_LIMIT = (12..14).to_a

class Game
  attr_accessor :id, :color_sets

  def initialize(id, color_sets)
    @id = id.to_i
    @color_sets = color_sets
  end

  def valid?(limit)
    @color_sets.all? do |set|
      set.zip(limit).all? { _1.reduce(&:<=) }
    end
  end
end

def extract_colors(game)
  COLORS_RE.map { |re| game[re]&.[](/\d+/).to_i }
end

def silver(games)
  games.select { _1.valid? SILVER_LIMIT }
       .map(&:id)
       .sum
end

def gold(games)
  games.map(&:color_sets)
       .map(&:transpose)
       .map { _1.map(&:max).reduce(&:*) }
       .sum
end

games = $<.each_line
          .map { |ln| [ln[/\d+/], ln.split(';').map { extract_colors _1 }] }
          .map { Game.new(*_1) }

puts [silver(games), gold(games)]
