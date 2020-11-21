#!/usr/bin/env python3
import regex as re


def decompress(line, recurv=False):
    size = 0
    i = 0
    while i < len(line):
        while i < len(line) and line[i] != '(':
            i += 1
            size += 1
        if i == len(line):
            break

        i += 1

        sublen = 0
        cycles = 0

        while line[i] != 'x':
            sublen *= 10
            sublen += int(line[i])
            i += 1
        i += 1

        while line[i] != ')':
            cycles *= 10
            cycles += int(line[i])
            i += 1
        i += 1

        if recurv:
            size += cycles * decompress(line[i:i + sublen], recurv)
        else:
            size += cycles * sublen
        i += sublen

    return size


file = re.sub("\s+", '', open("input/09.txt").read())
print(decompress(file))
print(decompress(file, recurv=True))
