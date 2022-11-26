#!/usr/bin/env ruby
# frozen_string_literal: true

class SnailNum
  attr_accessor :data, :left, :right, :depth, :type

  def initialize(val, depth = 0)
    @depth = depth

    if Integer === val
      @data = val
      @type = :leaf
    elsif Array === val
      @type = :node

      %i[left right]
        .zip(val)
        .each do |dir, v|
          set_member = ->(x) { dir == :left ? @left = x : @right = x }
          if SnailNum === v
            v.inc_depth!
            set_member.(v)
          else
            set_member.(SnailNum.new(v, depth + 1))
          end
        end
    end
  end

  def initialize_dup(snail)
    @data = snail.data
    @left = snail.left.dup
    @right = snail.right.dup
    @depth = snail.depth
    @type = snail.type
  end

  def leaf? = @type == :leaf
  def node? = @type == :node

  def inc_depth!
    @depth += 1
    @left&.inc_depth!
    @right&.inc_depth!
  end

  def magnitude
    return @data if leaf?
    @left.magnitude * 3 + @right.magnitude * 2
  end

  def +(snail)
    ret =
      SnailNum.new(
        [[@left.dup, @right.dup], [snail.left.dup, snail.right.dup]],
      )
    ret.reduce!
    ret
  end

  def reduce!
    reduce! if recur_explode!
    reduce! if split!
  end

  def recur_explode!
    return explode! if @depth == 4 && node?

    if (res = @left&.recur_explode!)
      left, right = res

      if @right.node? && right
        @right.push_down! [nil, right]
      elsif right
        @right.data += right
      end

      return left, nil
    end

    if (res = @right&.recur_explode!)
      left, right = res

      if @left.node? && left
        @left.push_down! [left, nil]
      elsif left
        @left.data += left
      end

      return nil, right
    end

    false
  end

  def explode!
    ret = [@left.data, @right.data]
    @left = @right = nil
    @data = 0
    @type = :leaf
    ret
  end

  def push_down!(res)
    return if !res || !res.any?

    left, right = res
    if right
      if @left&.leaf?
        @left.data += right
      elsif @left
        @left.push_down! res
      end
    else
      if @right&.leaf?
        @right.data += left
      elsif @right
        @right.push_down! res
      end
    end
  end

  def split!
    if leaf? && @data >= 10
      @left = SnailNum.new(@data / 2, @depth + 1)
      @right = SnailNum.new((@data.to_f / 2.0).ceil, @depth + 1)
      @data = nil
      @type = :node
      return true
    end

    [@left, @right].any? { _1&.split! }
  end
end

snail_nums = $<.readlines(chomp: true).map { SnailNum.new(eval _1) }

Silver = snail_nums.reduce(:+).magnitude
Gold =
  snail_nums
    .combination(2)
    .lazy
    .map { [_1 + _2, _2 + _1].lazy.map(&:magnitude).max }
    .max

puts "Day 18\n",
     "============================\n",
     "✮: #{Silver}\n",
     "★: #{Gold}"
