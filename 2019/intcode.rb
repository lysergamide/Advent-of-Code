# frozen_string_literal: true

# AoC 2019 intcode machine

require "set"

class Machine
  # class for parameters because why not
  class Param
    attr_accessor :val, :mode

    def initialize(tape)
      @val = 0
      @mode = false
      @tape = tape
    end

    def clear
      @val = 0
      @mode = false
    end

    def get; mode ? val : @tape[val]; end
    def +(par); self.get + par.get; end
    def *(par); self.get * par.get; end
    def <(par); self.get < par.get; end
    def ==(par); self.get == par.get; end
    def zero?; self.get.zero?; end
    def puts; puts @val; end
  end

  def initialize(tape)
    @tape = tape.dup
    @pc = 0
    @opcode = 0
    @fst = Param.new @tape
    @snd = Param.new @tape
    @thd = Param.new @tape
  end

  def opcycle
    puts "called"
    case @opcode
    when 1 #add
      @thd.val = @fst + @snd
      @pc += 4
    when 2 #mul
      @thd.val = @fast * @snd
      @pc += 4
    when 3 #gets
      @thd.val = $stdin.gets.to_i
      @pc += 2
    when 4 #puts
      @thd.puts
      @pc += 2
    when 5 #jmp
      @pc = !@fst.zero? ? @snd.get : 3 + @pc
    when 6 #njmp
      @pc = @fst.zero? ? @snd.get : 3 + @pc
    when 7 #less
      t[z] = @fst < @snd ? 1 : 0
      @pc += 4
    when 8 #eq
      t[z] = @fst == @snd ? 1 : 0
      @pc += 4
    else
      puts "BAD OP #{@opcode}"
      $stdin.gets
    end
  end

  def run(a = nil, b = nil)
    @tape[1] = a if !a.nil?
    @tape[2] = b if !b.nil?

    @pc = 0
    until @tape[@pc] == 99
      @fst.mode = (@tape[@pc] % 1000) > 99
      @snd.mode = @tape[@pc] >= 1000

      @opcode = @tape[@pc] % 100
      @fst.val = @tape[@pc + 1]
      @snd.val = @tape[@pc + 2]
      @thd.val = @tape[@pc + 3]

      self.opcycle
      puts @opcode
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
