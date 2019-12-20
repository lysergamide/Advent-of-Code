#!/usr/bin/env ruby
# frozen_string_literal: true

WIDTH  = 25
HEIGHT = 6

layers = File.read(ARGV.first)
             .chomp
             .split('')
             .each_slice(WIDTH * HEIGHT)
             .to_a

silver = layers.min_by { |layer| layer.count '0' }
               .then { |min| min.count('1') * min.count('2') }

gold =
  (0..HEIGHT * WIDTH - 1).map { |i|
    pixel = layers.map { |l| l[i] }
                  .find { |x| x < '2' }

    case pixel
    when '0' then '░░'
    when '1' then '██'
    when nil then ' '
    end
  }
  .each_slice(WIDTH)
  .map(&:join)
  .join("\n")

puts(
  "Day 08\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: \n#{gold}"
)