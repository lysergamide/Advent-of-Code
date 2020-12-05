#!/usr/bin/env ruby -w
# frozen_string_literal: true

require "set"

def part1(data)
  data.length == 8 || data.length == 7 && data.none? { _1.start_with? "cid" }
end

def part2(entry)
  eye_colors = Set.new(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]).freeze

  entry.all? do |pair|
    label, field = pair.split ":"

    case label
    when "byr" then (1920..2002).cover? field.to_i
    when "iyr" then (2010..2020).cover? field.to_i
    when "eyr" then (2020..2030).cover? field.to_i
    when "hgt"
      /^(?<h>\d+)(?<q>cm|in)$/ =~ field
      if q == "cm"
        (150..193).cover? h.to_i
      else
        (59..76).cover? h.to_i
      end
    when "hcl" then /^#[0-9a-f]{6}$/ =~ field
    when "ecl" then eye_colors.include? field
    when "pid" then /^\d{9}$/ =~ field
    when "cid" then true
    else false
    end
  end
end

LINES = File.read("input/04.txt", chomp: true)
  .split("\n\n")
  .map { _1.tr("\n", " ").split }
  .filter { part1 _1 }

silver = LINES.length
gold = LINES.count { part2 _1 }

puts(
  "Day 04\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
