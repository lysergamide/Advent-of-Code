#!/usr/bin/env ruby
# frozen_string_literal: true

class Node
  attr_accessor :name, :parent, :children

  def self.Root =
    @@Root ||= Node.new('/')

  def initialize(name, parent = nil, size = nil, children = [])
    @name, @parent, @size, @children = name, parent, size, children
  end

  def size =
    (@size ||= @children.sum(&:size))

  def silver =
    @children.sum(&:silver) +
      (@children.empty? || self.size > 100_000 ? 0 : self.size)

  def gold =
    [@size, *@children.map(&:gold)]
      .compact
      .select { @@Root.size - _1 <= 40_000_000 }
      .min
end

$<.readlines
  .reduce(Node.Root) do |node, line|
    case line
    when /\$ cd \//
      node = Node.Root
    when /\$ cd \.{2}/
      node = node.parent
    when /dir (?<name>.*)/
      node.children << Node.new($~[:name], node)
    when /(?<size>\d+) (?<name>.*)/
      node.children << Node.new($~[:name], node, $~[:size].to_i)
    when /\$ cd (?<name>\w+)/
      node = node.children.find { _1.name == $~[:name] }
    end

    node
  end

puts "Day 07\n",
     "============================\n",
     "✮: #{Node.Root.silver}\n",
     "★: #{Node.Root.gold}"
