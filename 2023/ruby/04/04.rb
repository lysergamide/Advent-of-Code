#!/usr/bin/env ruby
# frozen_string_literal: true

cards = $<.readlines(chomp: true)
          .compact
          .map { |line| line.split(/:|\|/).drop(1).map { _1.scan(/\d+/).map(&:to_i) } }

def matching(winning, lotto)
  @cache ||= {}
  return @cache[[winning, lotto]] if @cache.include? [winning, lotto]

  wset = winning.to_set
  @cache[[winning, lotto]] = lotto.count { wset.include? _1 }
end

def total_cards(cards)
  cards_count = [1] * cards.size

  cards.each_index do |idx|
    (idx.succ..idx + matching(*cards[idx]).to_i).each do |jdx|
      cards_count[jdx] += 1 * cards_count[idx]
    end
  end

  cards_count.sum
end

puts cards.map { (2**matching(*_1).pred).floor }.sum
puts total_cards(cards)
