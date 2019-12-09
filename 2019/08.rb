#!/usr/bin/env ruby
# frozen_string_literal: true

WIDTH  = 25
HEIGHT = 6

layers = File.read(ARGV.first)
             .chomp
             .split("")
             .each_slice(WIDTH * HEIGHT)
             .to_a

layers.min_by { |layer| layer.count "0" }
      .tap { |min| puts min.count("1") * min.count("2") }

image =
  (0..HEIGHT * WIDTH - 1).map do |i|
    pixel = layers.map { |l| l[i] }
                  .find { |x| x < "2" }

    case pixel
    when "0" then "░░"
    when "1" then "██"
    when nil then " "
    end
  end

image.each_slice(WIDTH) do |row|
  puts row.join
end
