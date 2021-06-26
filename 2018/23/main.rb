# frozen_string_literal: true

require 'pp'
require 'set'

class Bot
  attr_accessor :pos, :radius

  def initialize(pos, radius)
    @pos = pos
    @radius = radius
  end

  def intercept?(point)
    @radius >= @pos.zip(point).map { (_1 - _2).abs }.sum
  end
end

class Cube
  attr_accessor :top_right, :bottom_left

  def initialize(tr, bl)
    @top_right = tr
    @bottom_left = bl
  end

  def nearest_point(pos)
    bottom_left.zip(top_right).each_with_index.map do |r, i|
      if (r[0]..r[1]).cover?(pos[i])
        pos[i]
      else
        r.min_by { (_1 - pos[i]).abs }
      end
    end
  end

  def contain?(bot)
    bot.intercept?(nearest_point(bot.pos))
  end

  # split the cube into 8 subcubes
  def split
    # 8x8 cube
    singles = @top_right.zip(@bottom_left).all? { (_1 - _2) <= 1 }
    mid     = @top_right.zip(@bottom_left).map { (_1 + _2) / 2 }
    coords  = (0..2).map { [mid[_1], @top_right[_1], @bottom_left[_1]] }

    (0..7).map do |bit|
      ivec = 2.downto(0).map { (bit >> _1) & 1 }
      tr   = coords.zip(ivec).map { _1[_2] }
      bl   = coords.zip(ivec).map { _1[_2 - 1] }

      singles ? Cube.new(tr, tr) : Cube.new(tr, bl)
    end
  end

  def point?
    @top_right == @bottom_left
  end

  def scan(bots)
    bots.filter { contain? _1 }
  end

  def to_s
    "Cube{TR: #{top_right}, BL: #{bottom_left}"
  end
end

def oct_scan(cube, bots, depth = 0)
  @ret ||= nil
  @depths ||= Hash.new { |h, k| h[k] = 1 }

  if cube.point?
    if @ret.nil? || bots.size > @depths[depth]
      @depths[depth] = bots.size
      @ret = cube.top_right
    elsif bots.size == @depths[depth]
      @ret = [@ret, cube.top_right].min_by { _1.map(&:abs).sum }
    end

    return
  end

  return if @depths[depth] >= bots.size

  @depths[depth] = [@depths[depth], bots.size].max
  cubes_next     = cube.split.map { [_1, _1.scan(bots), depth + 1] }
  max            = cubes_next.map { _2.size }.max

  cubes_next.filter { _2.size == max }
            .sort_by { _1[0].nearest_point([0, 0, 0]).map(&:abs).sum }
            .each { oct_scan(*_1) }

  [@ret, @ret.map(&:abs).sum]
end

bots = File.readlines('23.txt')
           .map { _1.match(/pos=<(.*)>, r=(\d+)/).captures }
           .map { Bot.new(_1.split(',').map(&:to_i), _2.to_i) }

silver = bots.max_by(&:radius)
             .then { |x| bots.count { x.intercept? _1.pos } }

gold = bots.flat_map(&:pos).map(&:abs).max.then do |limit|
  oct_scan(Cube.new([limit] * 3, [-limit] * 3), bots)
end

puts "Silver: #{silver}\nGold: #{gold}"
