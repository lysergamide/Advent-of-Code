# frozen_string_literal: true

I = File.readlines("input", chomp: true).map(&:chars)

class Array
  def tmap(&b) = self.transpose.map(&b)
  def to_int2 = self.join.to_i(2)

  def freq
    ret = self.reduce(Hash.new(0)) { |h, k| h[k] += 1; h }
              .minmax_by(&:last)
              .transpose

    ret[1].reduce(:==) ? ["0", "1"] : ret[0]
  end
end

def gas_solver(&cond)
  I.each_index.reduce(I) do |nums, i|
    break nums.to_int2 if nums.size == 1

    key = cond[nums.map{ _1[i] }.freq]
    nums.filter { _1[i] == key }
  end
end

Silver = I.tmap { _1.freq }
          .tmap { _1.to_int2 }
          .reduce :*

Gold = gas_solver(&:first) * gas_solver(&:last)

puts "Day 03\n",
"==================\n",
"✮: #{Silver}\n",
"★: #{Gold}"