import re


class Assembunny:
    def __init__(self) -> None:
        self.reg = [0] * 4
        self.pc = 0

    def clear(self):
        self.reg = [0] * 4
        self.pc = 0

    def incPC(fn):
        def wrapper(self, *args, **kwargs):
            fn(self, *args, **kwargs)
            self.pc += 1
        return wrapper

    def fetchVal(self, x):
        return int(x) if x.strip('-').isdigit() else self.reg[ord(x) - ord('a')]

    @incPC
    def cpy(self, x, y):
        self.reg[ord(y) - ord('a')] = self.fetchVal(x)

    @incPC
    def inc(self, x):
        self.reg[ord(x) - ord('a')] += 1

    @incPC
    def dec(self, x):
        self.reg[ord(x) - ord('a')] -= 1

    def jnz(self, x, y):
        if self.fetchVal(x) != 0:
            self.pc += self.fetchVal(y)
        else:
            self.pc += 1

    def load(self, prog):
        self.prog = prog

    def step(self):
        switcher = {
            "cpy": lambda x: self.cpy(*x),
            "inc": lambda x: self.inc(*x),
            "dec": lambda x: self.dec(*x),
            "jnz": lambda x: self.jnz(*x),
        }

        op, args = re.match(r'^(\w+) (\w+.*)', self.prog[self.pc]).groups()
        args = args.split()
        switcher[op](args)

    def run(self):
        while self.pc < len(self.prog):
            self.step()


bunny = Assembunny()
bunny.load([line.strip() for line in open('input/12.txt').readlines()])
bunny.run()
print(bunny.reg[0])
bunny.clear()
bunny.reg[2] = 1
bunny.run()
print(bunny.reg[0])
