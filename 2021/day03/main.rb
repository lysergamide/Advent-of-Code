# frozen_string_literal: true

class Array
  def tmap(&b) = self.transpose.map(&b)

  def freq(&block)
    block ||= :last

    self.reduce(Hash.new(0)) { |h, k| h[k] += 1; h }
        .minmax_by(&block)
        .transpose
  end
end

def oxySolver(str, &cond)
  I.each_index.reduce(I) do |nums, i|
    return nums.first.to_i(2) if nums.size == 1

    key, counts = nums.map { _1[i] }.freq(&cond)
    key         = counts.reduce(:==) ? str : key.last

    nums.filter { _1[i] == key }
  end
end

I = File.readlines("input", chomp: true)

Silver = I.map(&:chars)
          .tmap { _1.freq.first }
          .tmap { _1.join.to_i(2) }
          .reduce :*

Gold = oxySolver("1") * oxySolver("0"){ - _1.last }

puts "Day 03\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"