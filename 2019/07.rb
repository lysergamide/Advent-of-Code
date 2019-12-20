#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'

def run_phase(tape, stack)
  tmp = 0
  until stack.empty?
    x = Interpreter.new(tape, false)
    x.input << stack.pop
    x.input << tmp
    x.run
    tmp = x.output.last
  end
  tmp
end

def feed_back(tape, nums)
  coroutines = nums.map { |_| Interpreter.new(tape, false) }

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

tape = File.read(ARGV.first)
           .split(',')
           .map(&:to_i)

ranges    = [(0..4), (5..9)].map(&:to_a)
functions = [method(:run_phase), method(:feed_back)]

silver, gold =
  ranges.zip(functions)
        .map do |range, fn|
          range.permutation(5)
               .map { |x| fn.(tape, x) }
               .max
        end

puts(
  "Day 07\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)