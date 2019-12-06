#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

class Planet < Array
  def count_orbit(x = 0)
    return x if self[1].empty?
    x + self[1].sum { |child| child.count_orbit(x + 1) }
  end

  def find_path(target, path = Array.new)
    return nil if self[1].empty?
    path << self[0]
    return path if self[1].any? { |a| a.first == target }

    self[1].map { |child| child.find_path(target, path.dup) }
      .compact
      .first
  end

  def fetch(target)
    return self if self[0] == target
    return nil if self[1].empty?
    self[1].map { |child| child.fetch(target) }
      .compact
      .first
  end

  def dist(target, x = -1)
    return x if target == self[0]
    return nil if self[1].empty?

    self[1].map { |child| child.dist(target, x + 1) }
      .compact
      .first
  end
end

lines = File.readlines(ARGV.first)
root = Planet["COM)", []]

stack = [root]
until stack.empty?
  parent, ls = stack.pop

  lines.select { |ln| ln[/^.*\)/] == parent }.each do |child|
    child.gsub(/.*\)/, "").chomp.tap { |x|
      planet = Planet["#{x})", []]
      ls << planet
      stack << planet
    }
  end
end

puts root.count_orbit
you = "YOU)"
san = "SAN)"
ypath = root.find_path(you)
spath = root.find_path(san)
length = [ypath.size, spath.size].min - 1

connection_name =
  ypath.slice(0, length).reverse
    .zip(spath.slice(0, length).reverse)
    .detect { |a| a[0] == a[1] }
    .first

connection = root.fetch(connection_name)
puts [you, san].sum { |x| connection.dist(x) }
