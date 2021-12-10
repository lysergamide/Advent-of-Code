# /user/bin/env ruby
# frozen_string_literal: true

require 'set'

Shape = {
  0 => Set[:a, :b, :c, :e, :f, :g],
  1 => Set[:c, :f],
  2 => Set[:a, :c, :d, :e, :g],
  3 => Set[:a, :c, :d, :f, :g],
  4 => Set[:b, :c, :d, :f],
  5 => Set[:a, :b, :d, :f, :g],
  6 => Set[:a, :b, :d, :e, :f, :g],
  7 => Set[:a, :c, :f],
  8 => Set[:a, :b, :c, :d, :e, :f, :g],
  9 => Set[:a, :b, :c, :d, :f, :g],
}

Digits     = Shape.keys
Size       = Digits.reduce(Hash.new) { |h, k| h[k] = Shape[k].size; h }
UniqueSize = [1, 4, 7, 8].map{ Size[_1] }.to_set

def solve(line)
  unsolved = line.to_set
  shapeMap = Hash.new
  used     = Set.new

  subset = ->(code) do
    shapeMap.select{ _1 < code}
            .map{ Shape[_2] }
            .reduce(&:|)
  end

  superset = ->(code) do
    shapeMap.select{ _1 > code}
            .min_by{ _1.first.size }
            .then{  Shape[_2] } 
  end

  until unsolved.empty?

    unsolved.each do |code|
      digits = Digits.reject{ Size[_1] != code.size || used === _1}

      unless digits.size == 1
        subS   = subset.call(code)
        superS = superset.call(code)

        digits.select!{ Shape[_1] >= subS }   unless subS.nil?
        digits.select!{ Shape[_1] <= superS } unless superS.nil?
      end

      if digits.size == 1
        shapeMap[code] = digits.first
        unsolved.delete(code)
        used << digits.first
      end
    end

  end

  line[-4..].map{ shapeMap[_1] }.reduce{ |a, b| a * 10 + b }
end

I = $<.readlines(chomp: true)
      .map{ |line| line.scan(/\w+/).map{ _1.chars.to_set } }

Silver = I.map{ |line| line[-4..].count { |x| UniqueSize === x.size } }.sum
Gold   = I.map{ solve(_1) }.sum

puts "Day 08\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"