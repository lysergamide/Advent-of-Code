require 'set'

class Board
  attr_accessor :data

  def initialize(d)
    @data = d
    @sets = (d + d.transpose).map(&:to_set)
    @nums = d.flatten
  end

  def bingo?(xs)
    @sets.any? { |s| xs.count { s.include? _1 } == 5 }
  end

  def score(xs)
    lel = xs.to_set
    @nums.filter { !lel.include? _1 }.sum
  end
end

#I      = File.read("test", chomp: true).split("\n\n")
I      = File.read("input", chomp: true).split("\n\n")
Lots   = I.first.split(",").map(&:to_i)
Boards = I[1..].map { |board| board.lines.map { _1.split.map(&:to_i) } }
               .map { Board.new _1 } 

winning_board = nil
winning_num, windex = Lots.each.with_index.find do |n, i|
  winning_board = Boards.filter { _1.bingo? Lots[..i] }.first
  !winning_board.nil?
end

p winning_num * winning_board.score(Lots[..windex])

last_board = Boards.dup
last_num, lastdex = Lots.each.with_index.find do |n, i|
  last_board = last_board.filter { !_1.bingo? Lots[..i] }
  if last_board.size == 1 
    last_board = last_board.first
    true
  else
    false
  end
end

last_win = (lastdex..).find do |i|
  last_board.bingo? Lots[..i]
end

p Lots[last_win] * last_board.score(Lots[..last_win])