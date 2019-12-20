#!/usr/bin/env ruby
# frozen_string_literal: true

class Array
  def dy_dx(point)
    [point[0] - first,
     point[1] - last]
  end

  # rotate and flip the axis before determining angle
  def theta(point)
    dy, dx = dy_dx(point)
    Math.atan2(dx, -dy) % (2 * Math::PI)
  end

  def dist(point)
    dy, dx = dy_dx(point)
    Math.sqrt(dy**2 + dx**2)
  end

  def pos_los
    map do |rock|
      rest = self - rock
      los  = rest.group_by { |r| rock.theta(r) }

      [rock, los]
    end.max_by { |_, los| los.size }
  end
end

field =
  File.readlines(ARGV.first)
      .each_with_index
      .flat_map { |line, y|
        line.each_char
            .with_index
            .flat_map { |c, x| c == '#' ? [[y, x]] : [] }
      }

pos, los = field.pos_los

silver = los.size
gold   = los.sort[199]
            .last
            .min_by { |rock| pos.dist(rock) }
            .then { |y, x| x * 100 + y }
puts(
  "Day 10\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)