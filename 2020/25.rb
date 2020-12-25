#!/usr/bin/env ruby -w
# frozen_string_literal: true

MOD = 20201227
File.readlines("input/25.txt").map(&:to_i).tap do |c, d|
  puts("Day 25\n" \
  "==================\n" \
  "★: #{c.pow((1..).find { 7.pow(_1, MOD) == d }, MOD)}")
end
