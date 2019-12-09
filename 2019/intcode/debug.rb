# frozen_string_literal: true

class Interpreter
  def debug
    info = (1..3).to_a.map { |i| [@mode[i].zero? ? 'P' : 'I', @tape[@sp + i], self[i]] }
    @trace << "B: #{@tape[@sp]} SP: #{@sp}"
    @trace << info.to_s
  end
end
