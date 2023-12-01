#! /usr/bin/env python3

from collections import Counter
from functools import reduce
from operator import mul, eq
from sys import stdin
from itertools import combinations, dropwhile


def tally(id):
    return Counter(Counter(id).values())

def extractPairs(t):
    return (t[2] >= 1, t[3] >= 1)

def addPair(p1, p2):
    return map(sum, zip(p1, p2))

def createPairsFromIds(ids):
    return (extractPairs(tally(id)) for id in ids)

def foldPairs(pairs):
    return reduce(addPair, pairs)

def checkSum(ids):
    return reduce(mul, foldPairs(createPairsFromIds(ids)))

def joinStrs(strs):
    return ''.join(map(lambda pair: pair[0] if pair[0] == pair[1] else '', zip(*strs)))

def findCorrectBoxIds(ids):
    return max(map(joinStrs, combinations(BOX_IDS, 2)), key=len)

BOX_IDS = [line.strip() for line in stdin]

print(checkSum(BOX_IDS))
print(findCorrectBoxIds(BOX_IDS))