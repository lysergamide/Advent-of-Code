#!/usr/bin/env ruby

def solve(tape, a, b)
  t = tape.dup
  t[1] = a
  t[2] = b

  i = 0
  until t[i] == 99
    x = t[i + 1]
    y = t[i + 2]
    z = t[i + 3]

    case t[i]
    when 1 then t[z] = t[x] + t[y]
    when 2 then t[z] = t[x] * t[y]
    end

    i += 4
  end

  t[0]
end

tape = File.read(ARGV.first).chomp.split(",").map &:to_i

puts solve(tape, 12, 2)

(0..99).to_a.permutation(2)
  .find { |a, b| solve(tape, a, b) == 19690720 }
  .tap { |a, b| puts a * 100 + b }
