#!/usr/bin/env ruby
# frozen_string_literal: true

require './intcode/intcode.rb'
#require 'set'

def fn(x)
  pos    = [0, 0]
  screen = Hash.new { |h, k| h[k] = []}
  prog   = Interpreter.new(x)

  i = 0
  until prog.done
    prog.opcycle
    next if prog.output.empty?

    out = prog.output.pop

    case i
    when 0 then pos[0]      = out
    when 1 then pos[1]      = out
    when 2 then screen[out] << pos.dup
    else
      puts "FUCKED UP"
    end
    
    i += 1
    i %= 3
  end
  screen
end

def fn2(x)
  pos    = [0, 0]
  screen = Hash.new { |h, k| h[k] = []}
  prog   = Interpreter.new(x)

  prog.tape[0] = 2

  i = 0
  score = 0
  until prog.done
    prog.opcycle

    if prog.peek_op == 3
      ball, paddle   = [4, 3].map { |x| screen.each_pair.find { |k, v| v == x }.first.first }
      move = ball <=> paddle
      prog.input.unshift(move)
    end
    next if prog.output.empty?

    out = prog.output.pop

    if pos == [-1, 0]
      score = out
    end

    case i
    when 0 then pos[0]      = out
    when 1 then pos[1]      = out
    when 2 then screen[pos.dup] = out
    end
    
    i += 1
    i %= 3
  end

  score
end


tape = File.read(ARGV.first)
           .split(',')
           .map(&:to_i)
silver = fn(tape)[2].size
gold   = fn2(tape)

puts(
  "Day 12\n"       \
  "======\n"       \
  "✮: #{silver}\n" \
  "★: #{gold}"
)