#!/usr/bin/env ruby 
# frozen_string_literal: true

require "set"

I = File.readlines("input/08.txt").map do |line|
  inst, arg = line.scan(/[^\s]+/)
  [inst.to_sym, arg.to_i]
end

class CPU
  attr_accessor :pc, :acc, :prog

  def initialize(prog)
    @pc = 0
    @acc = 0
    @prog = prog
  end

  def clear
    @pc = 0
    @acc = 0
  end

  def op_cycle
    op, arg = @prog[@pc]
    case op
    when :acc then @acc += arg
    when :nop
    when :jmp then @pc += arg - 1
    else puts "bad op: #{op}"
    end
    @pc += 1
  end

  def run
    seen = Set.new

    while @pc < @prog.size && @pc >= 0 && !seen.include?(@pc)
      seen << @pc
      op_cycle
    end

    @acc
  end

  def exit_succ?
    @pc == @prog.size
  end
end

silver = (cpu = CPU.new I).run
gold = cpu.tap {
  _1.prog.map(&:first)
    .each_with_index.select { |op, | op[0] == :nop || op == :jmp }
    .find { |op, i|
    cpu.clear
    cpu.prog[i][0] = op == :nop ? :jmp : :nop
    cpu.run
    cpu.prog[i][0] = op

    cpu.exit_succ?
  }
}.acc

puts(
  "Day 08\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
