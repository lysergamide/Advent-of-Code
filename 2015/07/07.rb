#!/usr/bin/env ruby
# frozen_string_literal: true

class Gate
  attr_accessor :op, :args

  def initialize(str)
    @op = case str
      when /.*NOT.*/    then ->(x) { ~x }
      when /.*OR.*/     then ->(a, b) { a | b }
      when /.*AND.*/    then ->(a, b) { a & b }
      when /.*RSHIFT.*/ then ->(a, b) { a >> b }
      when /.*LSHIFT.*/ then ->(a, b) { a << b }
      else                   ->(x) { x }
      end

    @args = str.gsub(/(NOT|OR|AND|LSHIFT|RSHIFT)/, "").strip.split(/\s+/)
  end
end

gates = Hash.new

File.open("07.txt").each_line do |line|
  left, right  = line.chomp.split " -> "
  gates[right] = Gate.new(left)
end

def solve(gates, set = nil)
  vals = Hash.new
  vals["b"] = set if !set.nil? # part 2

  until vals.member? "a"
    gates.each do |key, gate|
      next if vals.member? key
      next if !gate.args.all? { |x| !gates.member?(x) || vals.member?(x) }
      args = gate.args.map { |x| if gates.member? x then vals[x] else x.to_i end }
      vals[key] = gate.op.(*args)
    end
  end

  return vals["a"]
end

silver = solve(gates)
gold   = solve(gates, silver)

puts(
"Day 07
======
✮: #{silver}
★: #{gold}"
)
