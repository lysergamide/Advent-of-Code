#!/usr/bin/env ruby
# frozen_string_literal: true

I =
  $<.readlines(chomp: true).map { _1.tr("XYZABC", "123123").split.map(&:to_i) }

S = I.map { (_2 - _1) % 3 - 1 * 3 + _2 }.sum
G = I.map { (_2 + _1) % 3 + 1 + 3 * _2.pred }.sum

p S, G