# frozen_string_literal: true

class Interpreter
  def opcycle
    bytes = @tape[@sp]
    @opcode = bytes % 100

    (1..3).each do |i|
      @mode[i] = (bytes / (10 ** (1 + i))) % 10
    end

    debug if @dbg

    case @opcode
    when 1 # add
      self[3] = self[1] + self[2]
      @sp += 4
    when 2 # mul
      self[3] = self[1] * self[2]
      @sp += 4
    when 3 # gets
      if @input.empty?
        self[1] = $stdin.gets.to_i
      else
        self[1] = @input.shift
      end
      @sp += 2
    when 4 # puts
      @output << self[1]
      @sp += 2
    when 5 # jmp
      @sp = !self[1].zero? ? self[2] : 3 + @sp
    when 6 # njmp
      @sp = self[1].zero? ? self[2] : 3 + @sp
    when 7 # less
      self[3] = self[1] < self[2] ? 1 : 0
      @sp += 4
    when 8 # eq
      self[3] = self[1] == self[2] ? 1 : 0
      @sp += 4
    when 9
      @base = @base + self[1]
      @sp += 2
    when 99
      @done = true
    else
      puts "BAD OP #{@opcode}"
      if @dbg
        puts "p: dump @tape
" "s: stack trace
" "q!: kill program
" "q: continue with broken program "

        inp = $stdin.gets.chomp
        until inp == "q"
          case inp
          when "p" then puts @tape.to_s
          when "s" then puts @trace
          when "q!" then exit
          end
          inp = $stdin.gets.chomp
        end
      end
    end
  end
end
