#!/usr/bin/env ruby
# frozen_string_literal: true

p $<.readlines(chomp: true)
    .map { |x| x.split.map { _1.ord % 23 } }.map { 
      [1 + (_2 - _1 +1 ) % 3 * 3 + _2,
       1 + (_2 + _1 - 1) % 3 + 3 * _2]
    }
    .reduce{ _1.zip(_2).map &:sum }