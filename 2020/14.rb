#!/usr/bin/env ruby -w
# frozen_string_literal: true

nums = {}
nums2 = {}
mask = 0
indicies = []

File.readlines("input/14.txt").each do |line|
  if /mask/ =~ line
    mask = line.gsub("mask = ", "").strip
    indicies = (0...mask.size).filter { mask[_1] == "X" }
  else
    /mem\[(?<addr>\d+)\] = (?<n>\d+)/ =~ line
    #part1

    padded = n.to_i
      .to_s(2)
      .rjust(mask.size, "0")
    nums[addr.to_i] = padded.chars
      .zip(mask.chars)
      .map { _2 == "X" ? _1 : _2 }
      .join.to_i(2)

    #part2
    addr_mask = addr
      .to_i.to_s(2)
      .rjust(mask.size, "0")
      .chars
      .zip(mask.chars)
      .map { _2 == "0" ? _1 : _2 }.join

    (0..indicies.size).each do |i|
      indicies.combination(i).each do |comb|
        str = addr_mask.clone
        comb.each { str[_1] = "1" }
        str.tr!("X", "0")
        nums2[str.to_i(2)] = n.to_i
      end
    end
  end
end

puts("Day 13\n" \
"==================\n" \
"✮: #{nums.each_value.sum}\n" \
"★: #{nums2.each_value.sum}")
