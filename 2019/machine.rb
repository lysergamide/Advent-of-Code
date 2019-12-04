# AoC 2019 intcode machine

require "set"

class Machine
  def initialize(tape)
    @tape = tape.dup
    @pos = 0
  end

  def run(a, b)
    t = @tape.dup
    t[1] = a
    t[2] = b

    i = 0
    until t[i] == 99
      x = t[i + 1]
      y = t[i + 2]
      z = t[i + 3]

      case t[i]
      when 1 then t[z] = t[x] + t[y]
      when 2 then t[z] = t[x] * t[y]
      end

      i += 4
    end

    t[0]
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

  parsed = ops.map { |inst|
    line = Array.new(4)
    line[0] = op_names[inst[0]]

    (1..3).each do |i|
      muts << inst[i] if i == 3

      case inst[i]
      when 0 then line[i] = "[RET]"
      when 1 then line[i] = "[A]"
      when 2 then line[i] = "[B]"
      else
        if muts.include? inst[i]
          line[i] = "[#{inst[i].to_s}]"
        else
          line[i] = tape[inst[i]].to_s
        end
      end
    end

    op, fst, snd, dst = line

    if op == "RET"
      "RET"
    else
      "%-5s = %-5s %s %-5s" % [dst, fst, op, snd]
    end
  }

  parsed[0..parsed.find_index { |x| x == "RET" }]
end
