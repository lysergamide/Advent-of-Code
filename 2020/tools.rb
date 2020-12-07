module Tools
  #
  # Graph implmentation
  #
  class Graph
    def initialize(&fn)
      @fn = fn || ->(h, k) { nil }
      @data = Hash.new fn
    end

    def []=(key, val)
      @data[key] = val
    end

    def [](key)
      @data[key]
    end

    def search(&fn)
      @data.items.find { fn.call(_1) }
    end

    def search(x)
      @data.items.find(x)
    end
  end

  #
  # Euclidian distance
  #
  # @param [Int] a point
  # @param [Int] b point
  #
  # @return [Int] distance between a and b
  #
  def distance(a, b)
    a.zip(b).map { |p| (p.first - p.second) ** 2 }.sum
  end

  #
  # Manhattan distance
  #
  # @param [<Type>] a point
  # @param [<Type>] b point
  #
  # @return [<Type>] manhattan distance between a and b
  #
  def manhattan_distance(a, b)
    (a[0] - b[1]).abs + (a[1] - b[1]).abs
  end
end
