#!/usr/bin/env ruby

class Sector
  attr_reader :id

  def initialize(str)
    caps = str.match(/^(\D+)(\d+)\[(.*)\]/).captures
    @rubish, id, @checksum = caps

    @id = id.to_i
  end

  def to_s
    puts "id       => #{@id} \n" \
         "checksum => #{@checksum} \n" \
         "rubish   => #{@rubish}"
  end

  def valid?
    sorted_rubish = @rubish.gsub(/-/, "")
      .chars
      .sort_by { |c| [-(@rubish.count c), c] }
      .uniq
      .join

    sorted_rubish.start_with? @checksum
  end

  #Caesar shift
  def decrypt
    @rubish.chars.collect { |c|
      if c == "-"
        " "
      else
        tmp = ((c.ord - "a".ord + @id) % 26)
        (tmp + "a".ord).chr
      end
    }.join
  end
end

lines = File.readlines(ARGV.first)
secs = lines.map { |l| Sector.new(l) }.select &:valid?

puts secs.sum &:id
puts secs.find { |s| s.decrypt.include? "north" }.id
