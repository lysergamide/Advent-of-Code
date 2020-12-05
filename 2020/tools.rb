module Tools
  class Graph
    def initialize(&fn)
      fn ||= ->(h, k) { nil }
      @data = Hash.new fn
    end

    def []=(key, val)
      @data[key] = val
    end

    def search(&fn)
      @data.items.find { fn _1 }
    end
  end

  # distance between points, works for 2d or 3d
  def distance(a, b)
    a.zip(b).map { |p| (p.first - p.second) ** 2 }.sum
  end

  def manhattan_distance(a, b)
    (a[0] - b[1]).abs + (a[1] - b[1]).abs
  end
end
