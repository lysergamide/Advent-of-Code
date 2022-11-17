#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'pp'
require 'set'

class Dot
  @@REF_Y = Matrix[[-1, 0], [0, 1]]
  @@REF_X = Matrix[[1, 0], [0, -1]]

  def initialize(pos)
    @pos = case pos
           when Vector then pos
           when String then Vector[*pos.split(",").map(&:to_i)]
           else puts "RECIEVED #{pos.class}"
           end
  end

  def fold(ref, shift) = Dot.new(ref*(@pos - shift) + shift)
  def foldleft(x)      = @pos[0] <= x ? Dot.new(@pos) : fold(@@REF_Y, Vector[x, 0])
  def foldup(y)        = @pos[1] <= y ? Dot.new(@pos) : fold(@@REF_X, Vector[0, y])

  def to_a = @pos.to_a
end

class Instruction
  def initialize(str)
    dir, xy = str.match(/(x|y)=(\d+)/).captures

    @op = case dir
          when "y" then ->(dots){ dots.foldup(xy.to_i) }
          when "x" then ->(dots){ dots.foldleft(xy.to_i) }
          end
  end

  def apply(dots) = dots.map &@op
end

LINES, INS = $<.read.strip.split("\n\n").map{ _1.split "\n" }

dots = LINES.map{ Dot.new _1 }
ins  = INS.map{ Instruction.new _1 }

Silver = ins.first.apply(dots).uniq(&:to_a).size
Gold   = ins.reduce(dots){ _2.apply _1 }.map(&:to_a).uniq.then do |dots|
  dots_set = dots.to_set
  max = dots_set.lazy.map(&:max).max
  (0..max).map do |y|
    (0..max).map do |x|
      dots_set === [x,y] ? "█" : " "
    end.join
  end.reject{ /^\s+$/ =~ _1 }.join "\n"
end


puts "Day 13\n",
"==================\n",
"✮: #{Silver}\n",
"★:\n#{Gold}"