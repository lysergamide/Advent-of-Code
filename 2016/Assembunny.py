# AoC assembunny interpreter
import re


class Assembunny:

    def __init__(self, prog) -> None:
        self.reg = [0] * 4
        self.pc = 0
        self.prog = prog
        self.progcp = prog
        self.outbuff = []

    # Helper functions
    def clear(self):
        self.reg = [0] * 4
        self.pc = 0
        self.prog = self.progcp
        self.outbuff = []

    def incPC(self, x: int = 1):
        self.pc += x

    def fetchVal(self, x):
        return int(x) if x.strip('-').isdigit() else self.reg[ord(x) - ord('a')]

    # OP codes

    def cpy(self, x, y):
        if y.isalpha():
            self.reg[ord(y) - ord('a')] = self.fetchVal(x)
        self.incPC()

    def inc(self, x):
        if x.isalpha():
            self.reg[ord(x) - ord('a')] += 1
        self.incPC()

    def dec(self, x):
        if x.isalpha():
            self.reg[ord(x) - ord('a')] -= 1
        self.incPC()

    def jnz(self, x, y):
        if self.fetchVal(x) != 0:
            self.incPC(self.fetchVal(y))
        else:
            self.incPC()

    def tgl(self, x):
        index = self.pc + self.fetchVal(x)

        if index >= len(self.prog):
            self.incPC()
            return

        argsLen = len(re.match(r'^\w+ (.*)', self.prog[index])[1].split())

        if argsLen == 1:
            if re.search(r'^inc', self.prog[index]):
                self.prog[index] = re.sub(r'^inc', r'dec', self.prog[index])
            else:
                self.prog[index] = re.sub(r'^\w+', r'inc', self.prog[index])
        elif argsLen == 2:
            if re.search(r'^jnz', self.prog[index]):
                self.prog[index] = re.sub(r'^jnz', 'cpy', self.prog[index])
            else:
                self.prog[index] = re.sub(r'^\w+', 'jnz', self.prog[index])

        self.incPC()

    def out(self, x):
        self.outbuff.append(self.fetchVal(x))
        self.incPC()

    # single iteration

    def step(self):
        switcher = {
            "cpy": lambda x: self.cpy(*x),
            "inc": lambda x: self.inc(*x),
            "dec": lambda x: self.dec(*x),
            "jnz": lambda x: self.jnz(*x),
            "tgl": lambda x: self.tgl(*x),
            "out": lambda x: self.out(*x),
        }

        op, args = re.match(r'^(\w+) (.*)', self.prog[self.pc]).groups()
        args = args.split()
        switcher[op](args)

    # main loop
    def run(self):
        while self.pc < len(self.prog):
            self.step()
