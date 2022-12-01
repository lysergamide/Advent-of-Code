#!/usr/bin/env ruby
# frozen_string_literal: true

puts $<.read
       .split("\n\n")
       .map { _1.split.map(&:to_i).sum }
       .max(3)
       .then { [_1.max, _1.sum] }