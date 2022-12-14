#!/usr/bin/env ruby
# frozen_string_literal: true

require 'attr_extras'
require 'parallel'
require 'set'

class Monkey
  aattr_initialize :items, :operation, :test, :t, :f, :others, [count: 0]

  def ins(item) 
    @count += 1
    @operation.(item)
  end

  def testItem(item) = 
    @others[(item % @test == 0) ? @t : @f].items << item
  
  def playTurn() =
    until @items.empty?
      insp = ins(@items.shift)
      insp = yield insp
      testItem(insp)
    end

end

def getOp(x, y) =
  case x
  when "*" then ->(a) { a * (y == "old" ? a : y.to_i) }
  when "+" then ->(a) { a + (y == "old" ? a : y.to_i) }
  end

def scanDigits(str) =
  str.scan(/\d+/).map(&:to_i)

silver, gold = [], []

$<.readlines("\n\n", chomp: true).map do |monkeyText|
  arrs = monkeyText.lines(chomp: true)

  [silver, gold].each do |monkeys|
    monkeys << Monkey.new(
      scanDigits(arrs[1]),
      arrs[2].scan(/(\*|\+) (\d+|\w+)/).first.then{ getOp(*_1) },
      scanDigits(arrs[3]).first,
      scanDigits(arrs[4]).first,
      scanDigits(arrs[5]).first,
      monkeys
    )
  end
end

20.times do
  silver.each { |ms| ms.playTurn{ _1 / 3 } }
end

10000.times do
  gold.each { |ms| ms.playTurn{ _1 % gold.map(&:test).reduce(:*).freeze } }
end

puts [silver, gold].map { _1.map(&:count).max(2).reduce(:*) }