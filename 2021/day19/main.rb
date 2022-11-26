#!/usr/bin/env ruby
# frozen_string_literal: true

require "matrix"
require "set"

M = Matrix
V = Vector

ROT_MATS =
  (
    [M.identity(3)] +
      [
        M[[1, 0, 0], [0, 0, -1], [0, 1, 0]],
        M[[0, 0, 1], [0, 1, 0], [-1, 0, 0]],
        M[[0, -1, 0], [1, 0, 0], [0, 0, 1]],
      ].map { |mat| (0..3).map { mat**_1 } }
        .then { |ms| ms[0].product(*ms[1..]) }
        .map { _1.reduce :* }
        .uniq
  ).freeze

class Scanner
  attr_accessor :beacons, :cache, :origin

  def initialize(beacons, origin = V[0, 0, 0], cache = Hash.new)
    @beacons = beacons
    @cache = cache
    @origin = origin
  end

  def size = @beacons.size

  def rotate(r)
    new_cache = @cache.each_key.map { [_1, r * @cache[_1]] }.to_h
    Scanner.new(@beacons.map { r * _1 }, r * @origin, new_cache)
  end

  def translate(t)
    new_cache = @cache.each_key.map { [_1, @cache[_1] - t] }.to_h
    Scanner.new(@beacons.map { t + _1 }, t + @origin, new_cache)
  end

  def ==(scanner)
    return @cache[scanner] if @cache.include? scanner
    scanner
      .beacons
      .sample(2)
      .each do |b1|
        @beacons.sample(6).each do |b2|
          t = b2 - b1
          translated = scanner.beacons.map { _1 + t }.to_set
          if (@beacons.to_set & translated).size >= 12
            @cache[scanner] = t
            return t
          end
        end
      end
    nil
  end
end

class ScannerGroup < Array
  def initialize(scanners) = super(scanners)

  def rotate(rot) = ScannerGroup.new(self.map { _1.rotate rot })
  def translate(t) = ScannerGroup.new(self.map { _1.translate t })
  def ==(sg)
    self
      .product(sg)
      .each do
        ret = _1 == _2
        return ret if ret
      end
    return nil
  end

  def reduce
    self.map { _1.beacons.to_set }.reduce :|
  end
end

def part1(scanners)
  buckets = scanners.map { ScannerGroup.new [_1] }

  last = buckets.size
  until buckets.size == 1
    last = buckets.size if buckets.size != last
    front = buckets.first
    buckets =
      buckets
        .map { _1.rotate ROT_MATS.sample }
        .shuffle
        .chunk_while { _1 == _2 }
        .map do |chunk|
          chunk.reduce do |acc, b|
            t = acc == b
            ScannerGroup.new(acc + b.translate(t))
          end
        end
  end

  buckets.first
end

def part2(sg)
  os = sg.map(&:origin)
  os.product(os).map { |p1, p2| (p1 - p2).map(&:abs).sum }.max
end

scanners =
  $<
    .read
    .strip
    .split("\n\n")
    .map do |block|
      Scanner.new(block.split("\n")[1..].map { eval("V[#{_1}]") })
    end

Silver = part1(scanners)
Gold = part2(Silver)

puts "Day 19\n",
     "============================\n",
     "✮: #{Silver.reduce.size}\n",
     "★: #{Gold}"
