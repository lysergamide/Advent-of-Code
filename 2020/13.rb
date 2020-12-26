#!/usr/bin/env ruby 
# frozen_string_literal: true

N, I = File.readlines("input/13.txt").then { |a, b|
  [a.to_i, b.split(",")
    .each_with_index
    .reject { |a, | a == "x" }
    .map { [_1.to_i, _2] }]
}

def crm(n, a)
  prod = n.reduce { _1 * _2 }

  n.zip(a).sum { |n_i, a_i|
    pi = prod / n_i
    a_i * mul_inv(pi, n_i) * pi
  } % prod
end

def mul_inv(a, b)
  b0 = b
  x0, x1 = 0, 1
  return 1 if b == 1
  while a > 1
    q = a / b
    a, b = b, a % b
    x0, x1 = x1 - q * x0, x0
  end
  x1 += b0 if x1 < 0
  x1
end

silver = I
  .map(&:first)
  .min_by { N % _1 }
  .then { _1 * (_1 - (N % _1)) }
gold = crm(I.map(&:first), I.map { -_1.last })

puts(
  "Day 13\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
