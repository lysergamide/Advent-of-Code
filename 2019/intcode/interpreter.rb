# frozen_string_literal: true

# AoC 2019 intcode machine
require "./intcode/debug.rb"
require "./intcode/opcodes.rb"

class Interpreter
  attr_accessor :done, :input, :output, :opcode, :tape

  def initialize(tape, dbg = false)
    @tape   = Hash.new(0)
                  .tap { |h| tape.each_with_index { |x, i| h[i] = x } }

    @done   = false # Completion flag
    @dbg    = dbg   # Debug flag
    @base   = 0     # Current base
    @input  = []    # Input queue
    @output = []    # Output queue
    @mode   = []    # Mode flags
    @sp     = 0     # Current address
    @opcode = 0     # Current opcode
    @trace  = []    # Stack trace
  end

  def peek_op
    @tape[@sp] % 100
  end

  def [](i)
    case @mode[i]
    when 0 then @tape[@tape[@sp + i]] # position mode
    when 1 then @tape[@sp + i] # immediate mode
    when 2 then @tape[@tape[@sp + i] + @base]
    else
      puts "BAD MODE: #{i}"
    end
  end

  def []=(i, x)
    case @mode[i]
    when 0 then @tape[@tape[@sp + i]] = x
    when 2 then @tape[@tape[@sp + i] + @base] = x
    else
    end
  end

  def run(a = nil, b = nil)
    @tape[1] = a if !a.nil?
    @tape[2] = b if !b.nil?

    self.opcycle until @done
    @output.empty? ? @tape[0] : @output
  end
end
