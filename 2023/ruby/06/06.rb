#!/usr/bin/env ruby
# frozen_string_literal: true

RACES = $<.readlines(chomp: true)
          .map { _1.scan(/\d+/).map(&:to_i) }
          .transpose

def win_methods(time, distance)
  t1 = (time / 2.0) - Math.sqrt((time / 2.0)**2 - distance)
  t2 = (time / 2.0) + Math.sqrt((time / 2.0)**2 - distance)
  t1 = t1.floor.succ
  t2 = t2.ceil.pred

  (t2 - t1).succ
end

puts RACES.map { win_methods(*_1) }.reduce :*
puts win_methods(*RACES.transpose.map { _1.map(&:to_s).join.to_i })
