# frozen_string_literal: true

require 'set'

class Board < Array
  attr_reader :finish_time

  def initialize(arr)
    super(arr)
    @finish_time = 0
    @lots        = []
    @lines       = (arr + arr.transpose).map(&:to_set)
    @line_scores = Hash.new(0)
  end

  def addNum(x)
    @lots << x
    @finish_time += 1
    @lines.select{ _1.include? x }.each{ @line_scores[_1] += 1}
  end

  def bingo? = @line_scores.values.any?{ _1 == self.size }
  def score  = self.flatten.reject{ @lots.to_set.include? _1 }.sum * @lots[-1]
end

I      = File.read("input", chomp: true).split("\n\n")
Lots   = I.first.split(",").map(&:to_i)

boards = I[1..].map{ |b| Board.new(b.lines.map{ _1.split.map(&:to_i) }) }

Silver, Gold = Lots.reduce(boards) do |bs, x|
  break boards.minmax_by(&:finish_time) if bs.empty?

  bs.each{ _1.addNum x}.reject{ _1.bingo? }
end

puts "Day 03\n",
"==================\n",
"✮: #{Silver.score}\n",
"★: #{Gold.score}"