#!/usr/bin/env ruby
# frozen_string_literal: true

FIVE = 0
FOUR = 1
FULL_HOUSE = 2
THREE = 3
TWO_PAIR = 4
PAIR = 5

RANKS = [
  [5],
  [4, 1],
  [3, 2],
  [3, 1],
  [2, 2],
  [2, 1],
  [1, 1]
].each_with_index.to_h.freeze

NORMALIZED = [
  %w[A K Q J T],
  9.downto(2).map(&:to_s)
].flatten.zip(('a'..'z')).to_h.freeze

NORMALIZED_GOLD = [
  %w[A K Q T],
  9.downto(2).map(&:to_s),
  'J'
].flatten.zip(('a'..'z')).to_h.freeze

class Card
  attr_reader :rank, :str, :bet, :gold_rank, :gold_str

  def initialize(card_str)
    card, bet = card_str.strip.split
    @rank = RANKS[card.chars.tally.values.max(2)]
    @gold_rank = RANKS[card.chars.reject { _1 == 'J' }.tally.values.max(2).then { _1.empty? ? [5] : [_1[0] + card.chars.count('J').to_i, _1[1]].compact }]
    @str = card.chars.map(&NORMALIZED).join
    @gold_str = card.chars.map(&NORMALIZED_GOLD).join
    @bet = bet.to_i
  end

  def <=>(other)
    ret = other.rank <=> @rank
    ret.zero? ? (other.str <=> @str) : ret
  end

  def gold_ord(other)
    ret = other.gold_rank <=> @gold_rank
    ret.zero? ? (other.gold_str <=> @gold_str) : ret
  end
end

def winnings(cards)
  cards.each_with_index.map { _1.bet * _2.succ }.sum
end

cards = $<.readlines(chomp: true).map { Card.new _1 }.sort
puts winnings(cards)
puts winnings(cards.sort(&:gold_ord))
