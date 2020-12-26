#!/usr/bin/env python3

from collections import defaultdict
from functools import reduce
import regex as re


class Bot:
    def __init__(self, idNum: int, ltype: str, low: int, htype: str, high: int) -> None:
        self.idNum = int(idNum)
        self.ltype = ltype
        self.low = int(low)
        self.htype = htype
        self.high = int(high)

        self.chips = []

    def addChip(self, chip: int) -> None:
        self.chips.append(chip)


class Instruction:
    def __init__(self, chip: str, target: str, ttype: str) -> None:
        self.chip = int(chip)
        self.target = int(target)
        self.ttype = ttype


class Factory:
    def __init__(self) -> None:
        self.bots = {}
        self.outBin = defaultdict(list)
        self.instructions = []
        self.magicBot = None

    def addBot(self, bot) -> None:
        self.bots[bot.idNum] = bot

    def addInstruction(self, inst) -> None:
        self.instructions.append(inst)

    def run(self) -> None:
        self.instructions.reverse()

        while len(self.instructions) > 0:
            inst = self.instructions.pop()

            if inst.ttype == "bot":
                bot = self.bots[inst.target]
                bot.addChip(inst.chip)
                if len(bot.chips) > 1:
                    bot.chips.sort()

                    if bot.chips == [17, 61]:
                        self.magicBot = bot.idNum

                    self.instructions.append(
                        Instruction(bot.chips.pop(), bot.high, bot.htype))

                    self.instructions.append(
                        Instruction(bot.chips.pop(), bot.low, bot.ltype))
            else:
                self.outBin[inst.target].append(inst.chip)


factory = Factory()

for line in open('input/10.txt').readlines():
    if re.search(r'^value', line):
        vals = re.match(r'value (\d+) goes to bot (\d+)', line).groups()
        factory.addInstruction(Instruction(*vals, "bot"))
    elif line.strip():
        vals = re.match(
            r'bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)', line
        ).groups()
        factory.addBot(Bot(*vals))


factory.run()

print(factory.magicBot)
print(reduce(lambda a, b: a * b,
             map(lambda i: factory.outBin[i][0],  range(3))))
