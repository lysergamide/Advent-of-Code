# frozen_string_literal: true

require 'set'

def dasm(tape)
  opcopes = {
    1 => '+',
    2 => '*',
    3 => 'gets',
    4 => 'puts',
    5 => 'jump',
    6 => 'njump',
    7 => '<',
    8 => '==',
    99 => 'RET'
  }.freeze

  ops = tape.each_slice(4).reject { |t| t.size < 4 }.to_a
  muts = Set.new

  parsed = ops.map do |inst|
    line = Array.new(4)
    line[0] = opcodes[inst[0]][0]

    (1..3).each do |i|
      muts << inst[i] if i == 3

      line[i] =
        case inst[i]
        when 0 then '[RET]'
        when 1 then '[A]'
        when 2 then '[B]'
        else
          if muts.include? inst[i]
            "[#{inst[i]}]"
          else
            tape[inst[i]].to_s
          end
        end
    end

    op, fst, snd, dst = line

    if op == 'RET'
      'RET'
    else
      format('%-5s = %-5s %s %-5s', dst, fst, op, snd)
    end
  end

  parsed[0..parsed.find_index { |x| x == 'RET' }]
end
