#!/usr/bin/env ruby 
# frozen_string_literal: true

class List
  attr_accessor :head, :tail, :size

  class Node
    attr_accessor :data, :succ

    def initialize(x)
      @data = x
      @succ = nil
    end
  end

  def initialize
    @head = nil
    @tail = nil
    @size = 0
    @table = {}
  end

  def push(x)
    n = Node.new x
    @table[x] = n

    if @tail.nil?
      @head = n
      @tail = n
      @head.succ, @tail.succ = @tail, @head
    else
      @tail.succ = n
      @tail = n
      @tail.succ = @head
    end

    @size += 1
  end

  def empty?() @size == 0 end
  def peek() @head.data end
  def find(x) (@table.include? x) ? @table[x] : nil end
  def contain?(x) @table.include? x end

  def rip!
    ret = List.new

    3.times do
      tmp = @head.succ
      @head.succ = @head.succ.succ
      ret.push(tmp.data)
    end
    @size -= 3

    ret
  end

  def splice_after(n, lst)
    node = self.find(n)
    return nil if node.nil?

    node.succ, lst.tail.succ = lst.head, node.succ
    lst.size.times do
      @table[lst.peek] = lst.head
      lst.rot!
    end

    @size += lst.size
    self
  end

  def to_s
    node = @head
    return "List: {}" if node.nil?

    str = "List: { "
    loop do
      str += "#{node.data.to_s} -> "
      node = node.succ
      return str[..-5] + " }" if node.equal? @head
    end
  end

  def self.from_a(arr)
    ret = List.new
    arr.each { ret.push _1 }
    ret
  end

  def rot!(x = 1)
    return self if @head.nil?
    x.times { @head = @head.succ }
    self
  end

  def take(x)
    ret = []
    node = @head.succ
    x.times do
      return ret if node.nil?
      ret << node.data
      node = node.succ
    end
    ret
  end
end

def solve(arr, n)
  max = arr.max
  nums = List.from_a arr

  n.times do
    trips = nums.rip!
    x = nums.peek == 1 ? max : nums.peek - 1
    x = (x == 1 ? max : x - 1) while trips.contain?(x)
    nums.splice_after(x, trips)
    nums.rot!
  end

  nums.head = nums.find(1)
  nums
end

MIL = 1000000
I = File.read("input/23.txt", chomp: true).chars.map(&:to_i)

silver = solve(I, 100).take(8).join
gold = solve(I + (10..MIL).to_a, 10 * MIL).take(2).reduce(:*)

puts("Day 23\n" \
"==================\n" \
"✮: #{silver}\n" \
"★: #{gold}")
