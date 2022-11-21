#!/usr/bin/env ruby
# frozen_string_literal: true

class Packet
  attr_reader :version, :type, :value, :length, :sub_packets

  def initialize(bits)
    @bits = bits
    @version = @bits[0..2].to_i(2)
    @type = @bits[3..5].to_i(2)

    @type == 4 ? parse_literal : parse_operator
  end

  def parse_literal
    @length = 6
    @value =
      @bits[6..]
        .chars
        .each_slice(5)
        .reduce("") do |data, b|
          @length += 5
          data += b[1..].join
          break data if b.first == "0"
          data
        end
        .to_i(2)
  end

  def version_sum = @version + @sub_packets&.sum(&:version_sum).to_i
  def eval
    return @value if @type == 4
    @sub_packets
      .lazy
      .map(&:eval)
      .then do |values|
        case @type
        when 0
          values.sum
        when 1
          values.reduce :*
        when 2
          values.min
        when 3
          values.max
        when 5
          (values.first > values.drop(1).first) ? 1 : 0
        when 6
          (values.first < values.drop(1).first) ? 1 : 0
        when 7
          (values.first == values.drop(1).first) ? 1 : 0
        end
      end
  end

  @@BITS_START = 22
  @@BITS_RANGE = 7..21

  @@PACKS_START = 18
  @@PACKS_RANGE = 7..17

  def parse_operator
    @sub_packets ||= []

    idx = 0

    loop_body = ->(slice) do
      sub_packet = Packet.new slice[idx..]
      idx += sub_packet.length
      @length += sub_packet.length
      @sub_packets << sub_packet
    end

    if @bits[6] == "0"
      @length = @@BITS_START
      slice = @bits[@length..@length + @bits[@@BITS_RANGE].to_i(2)]
      loop_body.(slice) until idx >= slice.length - 1
    else
      @length = @@PACKS_START
      slice = @bits[@length...]
      @bits[@@PACKS_RANGE].to_i(2).times { loop_body.(slice) }
    end
  end
end

packet =
  Packet.new(
    $<.read.strip.chars.map { _1.to_i(16).to_s(2).rjust(4, "0") }.join,
  )

Silver = packet.version_sum
Gold = packet.eval

puts "Day 16\n",
     "============================\n",
     "✮: #{Silver}\n",
     "★: #{Gold}"
