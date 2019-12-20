#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

lines  = File.readlines(ARGV.first)

class Elements
  attr_accessor :name, :elems, :need, :min

  def initialize(str, n)
    @name  = str
    @min   = n
    @elems = []
    @need  = []
  end

  def base?
    return @elems == [["ORE"]]
  end

  def round(x)
    (x.to_f / @min).ceil * @min
  end

  def need?(str)
    @need[@elems.index(str)]
  end
end

formula = Hash.new

class String
  def parse
    n, x = self.split
    [x, n.to_i]
  end
end

elements = lines.map do |line|
  input, output = line.chomp.split("=>")
  name, out     = output.parse
  quants        = input.split(",").map(&:parse)

  elem = Element.new(name, out)

  quants.each do |sname, sneed|
    elem.elems << sname
    elem.need  << sneed
  end
  formula[name] = elem
end

def break_down(elems, target = "ORE")
  stack = [[formula[target]], 1]]
  bases = []

  until stack.empty?
    parent = stack.pop
    parent.elements
  end

end

silver = break_down(elements)
gold   = nil

puts(
  "Day 14\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)