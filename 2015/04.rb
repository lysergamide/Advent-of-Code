#!/usr/bin/env ruby

require 'digest'

input = File.read(ARGV.first).chomp

[5, 6].each do |n|
    zeroes = '0' * n

    (0 .. ).each do |x|
        digest = Digest::MD5.hexdigest(input + x.to_s)

        if (digest.start_with? zeroes)
            puts x
            break
        end
    end
end