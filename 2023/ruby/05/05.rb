#!/usr/bin/env ruby
# frozen_string_literal: true

class Range
  def +(other)
    (self.begin + other)..(self.end + other)
  end
end

class Mapping
  attr_accessor :source, :destination, :sub_mappings

  def initialize(source, destination)
    @source = source
    @destination = destination
  end

  def push(dst, src, range)
    @sub_mappings ||= {}
    @sub_mappings[(src..src + range.pred)] = dst - src
  end

  def [](num)
    return transform_range(num) if num.is_a?(Range)

    src = @sub_mappings.keys.find { _1.cover? num }
    src.nil? ? num : num + @sub_mappings[src]
  end

  def transform_range(seed_range)
    processed = []
    remaining = @sub_mappings.reduce([seed_range]) do |sub_seeds, sub_mapping|
      map_range, delta = sub_mapping
      left = map_range.begin
      right = map_range.end

      sub_seeds.flat_map do |r|
        if map_range == r || map_range.cover?(r)
          processed << [r + delta]
          break []
        elsif r.cover? map_range
          processed << map_range + delta
          [r.begin..left.pred, right.succ..r.end]
        elsif r.cover? left
          processed << (left..r.end) + delta
          [r.begin..left.pred]
        elsif r.cover? right
          processed << (r.begin..right) + delta
          [right.succ..r.end]
        else
          [r]
        end
      end
    end

    [processed + remaining].flatten.reject { _1.begin > _1.end }
  end
end

input = $<.read.chomp.split("\n\n")
seeds = input.first.scan(/\d+/).map(&:to_i)

MAPPINGS = input.drop(1).map do |map_description|
  /(?<src>\w+)-to-(?<dst>\w+)/ =~ map_description
  src, dst = [src, dst].map(&:to_sym)
  ret = Mapping.new src, dst
  map_description.split("\n").drop(1).each do |line|
    ret.push(*line.scan(/\d+/).map(&:to_i))
  end
  [ret.source, ret]
end.to_h

def reducer(seeds)
  acc = seeds.clone
  midx = MAPPINGS[:seed]

  until midx.nil?
    acc = acc.flat_map { midx[_1] }
    midx = MAPPINGS[midx.destination]
  end

  acc
end

puts reducer(seeds).min
puts reducer(seeds.each_slice(2).map { _1..(_1 + _2).pred }).map(&:begin).min
