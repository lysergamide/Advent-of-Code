# frozen_string_literal: true

# AoC 2019 intcode machine

require "set"

class Param
  attr_accessor :val, :mode

  def initialize(tape)
    @val = 0
    @immediate = false
    @tape = tape
  end

  def clear
    @val = 0
    @mode = true
  end

  def get; @immediate ? val : @tape[val]; end
  def +(par); self.get + par.get; end
  def *(par); self.get * par.get; end
  def <(par); self.get < par.get; end
  def ==(par); self.get == par.get; end
  def zero?; self.get.zero?; end
  def print; puts @val; end
end

class Tape
  def initialize(t)
    @vals = t.dup
  end

  def [](par)
    if par.is_a?(Param)
      @vals[par.get]
    else
      @vals[par]
    end
  end

  def []=(par, val)
    if par.is_a?(Param)
      @vals[par.get] = val
    else
      @vals[par] = val
    end
  end
end

class Machine
  # class for parameters because why not

  def initialize(t, dbg = false)
    @tape = Tape.new t
    @sp = 0
    @opcode = 0
    @fst = Param.new @tape
    @snd = Param.new @tape
    @thd = Param.new @tape
    @dbg = dbg
  end

  def debug
    puts "Bytes: #{@tape[@sp]}; SP: #{@sp} : OP: #{@opcode}
" \
         "fst: #{[@fst.get, @fst.mode ? "immediate" : "position"].to_s}
" \
         "snd: #{[@snd.get, @snd.mode ? "immediate" : "position"].to_s}
" \
         "thd: #{[@thd.get, @thd.mode ? "immediate" : "position"].to_s}"
  end

  def opcycle
    self.debug if @dbg
    case @opcode
    when 1 #add
      @tape[@thd] = @fst + @snd
      @sp += 4
    when 2 #mul
      @tape[@thd] = @fast * @snd
      @sp += 4
    when 3 #gets
      @tape[@thd] = $stdin.gets.to_i
      @sp += 2
    when 4 #puts
      @thd.print
      @sp += 2
    when 5 #jmp
      @sp = !@fst.zero? ? @snd.get : 3 + @sp
    when 6 #njmp
      @sp = @fst.zero? ? @snd.get : 3 + @sp
    when 7 #less
      @tap[@thd] = @fst < @snd ? 1 : 0
      @sp += 4
    when 8 #eq
      @tape[@thd] = @fst == @snd ? 1 : 0
      @sp += 4
    else
      puts "BAD OP #{@opcode}"
      $stdin.gets if @dbg
    end
  end

  def run(a = nil, b = nil)
    @tape[1] = a if !a.nil?
    @tape[2] = b if !b.nil?

    @sp = 0
    until @tape[@sp] == 99
      @fst.mode = (@tape[@sp] % 1000) > 99
      @snd.mode = @tape[@sp] >= 1000

      @opcode = @tape[@sp] % 100
      @fst.val = @tape[@sp + 1]
      @snd.val = @tape[@sp + 2]
      @thd.val = @tape[@sp + 3]

      self.opcycle
    end

    @tape[0]
  end
end

def dasm(tape)
  op_names = {
    1 => "+",
    2 => "*",
    99 => "RET",
  }.freeze

  ops = tape.each_slice(4).reject { |t| t.size < 4 }.to_a
  muts = Set.new

  parsed = ops.map do |inst|
    line = Array.new(4)
    line[0] = op_names[inst[0]]

    (1..3).each do |i|
      muts << inst[i] if i == 3

      line[i] =
        case inst[i]
        when 0 then "[RET]"
        when 1 then "[A]"
        when 2 then "[B]"
        else
          if muts.include? inst[i]
            "[#{inst[i]}]"
          else
            tape[inst[i]].to_s
          end
        end
    end

    op, fst, snd, dst = line

    if op == "RET"
      "RET"
    else
      format("%-5s = %-5s %s %-5s", dst, fst, op, snd)
    end
  end

  parsed[0..parsed.find_index { |x| x == "RET" }]
end
