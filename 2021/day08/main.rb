require 'set'

Nums = {
  0 => Set[:a, :b, :c, :e, :f, :g],
  1 => Set[:c, :f],
  2 => Set[:a, :c, :d, :e, :g],
  3 => Set[:a, :c, :d, :f, :g],
  4 => Set[:b, :c, :d, :f],
  5 => Set[:a, :b, :d, :f, :g],
  6 => Set[:a, :b, :d, :e, :f, :g],
  7 => Set[:a, :c, :f],
  8 => Set[:a, :b, :c, :d, :e, :f, :g],
  9 => Set[:a, :b, :c, :d, :f, :g],
}

NumSize   = Nums.map { [_1, _2.size] }.to_h
SizeNums  = NumSize.group_by(&:last).map{ [_1, _2.map(&:first)] }.to_h
SizeCount = NumSize.map{ _1.last }.tally

def parseLine(line)
  line.split("|")
      .map{ |side| side.split.map { _1.chars.to_set } }
end


I = $<.read.chomp.lines.map{ parseLine _1 }

def solveLine(input, output)
  ls     = input.to_set
  keyMap = Hash.new
  done   = Set.new

  output.each do |o|
    if SizeCount[o.size] == 1
      key = SizeNums[o.size].first
      keyMap[o] = key
      done << o
    end
  end

  ls -= done
  until ls.empty?
    ls.each do |x|
      candidates = SizeNums[x.size].reject { done.include? _1 }
                                   .select {}
      if candidates.size == 1
        key = candidates.first
        keyMap[x] = key
        done << key
      end
    end

    ls -= done
  end

  output.map { solved[_1] }
end

Silver = I.map(&:last)
          .map{ |sets| sets.count { |s| SizeCount[s.size] == 1 } }
          .sum
