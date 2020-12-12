#!/usr/bin/env ruby -w
# frozen_string_literal: true

I = File.readlines("input/12.txt").map { [_1[0], _1[1..].to_i] }

class Vec < Array
  def mul(c) Vec.new(map { _1 * c }) end
  def rot_left() tap { _1[0], _1[1] = _1[1], -_1[0] } end
  def rot_right() tap { _1[0], _1[1] = -_1[1], _1[0] } end
  def add(x) tap { _1[0] += x[0]; _1[1] += x[1] } end
end

D = {
  "N" => Vec.new([1, 0]),
  "E" => Vec.new([0, 1]),
  "S" => Vec.new([-1, 0]),
  "W" => Vec.new([0, -1]),
}

def navigate(dir = [0, 1], part2 = false)
  ship, waypoint = Vec.new([0, 0]), Vec.new(dir)

  I.each { |c, n|
    case c
    when "L" then (n / 90).times { waypoint.rot_left }
    when "R" then (n / 90).times { waypoint.rot_right }
    when "F" then ship.add(waypoint.mul n)
    else part2 ? waypoint.add(D[c].mul n) : ship.add(D[c].mul n)
    end
  }
  ship.map(&:abs).sum
end

puts(
  "Day 12\n" \
  "==================\n" \
  "✮: #{navigate}\n" \
  "★: #{navigate([1, 10], part2: true)}"
)
