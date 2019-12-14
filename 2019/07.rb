#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'


class Array
  def run_phase(stack)
    tmp = 0
    until stack.empty?
      x = Interpreter.new(self, false)
      x.input << stack.pop
      x.input << tmp
      x.run
      tmp = x.output.last
    end
    tmp
  end

  def feed_back(nums)
    coroutines = nums.map { |_| Interpreter.new(@tape, false) }

    coroutines.each_with_index do |r, i|
      size = coroutines.size
      succ = coroutines[(i + 1) % size].input
      pred = coroutines[(i - 1) % size].output

      r.input = pred
      succ    = r.output
    end

    coroutines.each_with_index do |r, i|
      r.input << nums[i]
    end
    coroutines.first.input << 0

    until coroutines.last.done
      coroutines.each do |r|
        r.opcycle unless (r.peek_op == 3) && r.input.empty?
      end
    end

    coroutines.last.output.last
  end
end

tape = File.read(ARGV.first)
            .split(',')
            .map(&:to_i)

silver, gold =
  [(0..4).to_a, (5..9).to_a]
    .zip([method(:run_phase), method(:feed_back)]) do |range, fn|
      range.to_a
           .permutation(5)
           .map(&fn) 
           .max
end

puts(
  "Day 07\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)

#puts (0..4).to_a
#           .permutation(5)
#           .map { |nums| run_phase(nums) }
#           .max
#
#puts (5..9).to_a
#           .permutation(5)
#           .map { |nums| feed_back(nums) }
#           .max
