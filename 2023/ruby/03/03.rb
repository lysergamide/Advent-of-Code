#!/usr/bin/env ruby
# frozen_string_literal: true

class FloodableMap
  @@N8 = (-1..1).to_a.product((-1..1).to_a).reject { _1 == [0, 0] }.freeze

  def n8(y, x)
    @@N8.map { |dy, dx| [dy + y, dx + x] }.reject { |arr| arr.any?(&:negative?) }
  end

  def initialize(schematic)
    @schematic = schematic
    @symbols = Hash.new false

    @schematic.each_with_index do |row, y|
      row.each_with_index do |chr, x|
        @symbols[[y, x]] = chr if /[^.\d\s]/ =~ chr
      end
    end
  end

  def get_numbers(&block)
    block ||= ->(_) { true }
    return @ret.select(&block).map(&:first) if @ret

    visited = Hash.new false
    @ret = @symbols.each_pair
                   .select(&block)
                   .map { |pos, sym| [n8(*pos).map { extract_num _1, _2, visited }.compact, sym] }
                   .reject { _1.first.empty? }

    @ret.select(&block).map(&:first)
  end

  def extract_num(y, x, visited)
    return if visited[[y, x]] || !(/\d/ =~ @schematic[y][x])

    numeric_xs(y, x).map do |dx|
      visited[[y, dx]] = true
      @schematic[y][dx]
    end
                    .join
                    .to_i
  end

  def numeric_xs(y, x)
    left_xs = x.downto(0).take_while { /\d/ =~ @schematic[y][_1] }
    right_xs = x.upto(@schematic.first.size.pred).take_while { /\d/ =~ @schematic[y][_1] }
    left_xs.reverse.union(right_xs)
  end
end

input = $<.each_line.map(&:chomp).compact.map(&:chars)
map = FloodableMap.new input

puts map.get_numbers
        .flatten
        .sum

puts map.get_numbers { _2 == '*' }
        .select { _1.size == 2 }
        .map { _1.inject :* }
        .sum
