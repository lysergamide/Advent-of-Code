# frozen_string_literal: true

# AoC 2019 intcode machine
require './intcode/debug.rb'
require './intcode/opcodes.rb'

class Interpreter
  attr_accessor :done, :input, :output, :opcode, :tape

  def initialize(tape, dbg = false)
    @done = false
    @tape = tape.dup
    @dbg = dbg

    @input = []
    @output = []

    @mode = []
    @sp = 0
    @opcode = 0

    @trace = []
  end

  def peek_op
    @tape[@sp] % 100
  end

  def [](i)
    case @mode[i]
    when 0 then @tape[@tape[@sp + i]] # position mode
    when 1 then @tape[@sp + i] # immediate mode
    else
      puts "BAD MODE: #{i} "
    end
  end

  def []=(i, x)
    @tape[@tape[@sp + i]] = x
  end

  def run(a = nil, b = nil)
    @tape[1] = a if !a.nil?
    @tape[2] = b if !b.nil?
    @sp = 0
    self.opcycle until @done
    @output.empty? ? @tape[0] : @output
  end
end
