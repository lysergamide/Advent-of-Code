#!/usr/bin/env python3

import numpy as np
import regex as re
import pprint as pp


class Screen:
    def __init__(self) -> None:
        self.screen = np.zeros([6, 50])

    def rect(self, x: int, y: int):
        for i in range(y):
            for j in range(x):
                self.screen[i][j] = 1

    def rotCol(self, x: int, n: int):
        t = self.screen.transpose()
        t[x] = np.roll(t[x], n)
        self.screen = t.transpose()

    def rotRow(self, y: int, n: int):
        self.screen[y] = np.roll(self.screen[y], n)

    def sum(self) -> int:
        return np.sum(self.screen)

    def disp(self) -> str:
        ret = ''
        for row in self.screen:
            for x in row:
                if x == 1:
                    ret += '#'
                else:
                    ret += ' '
            ret += '\n'
        return ret


def move(screen: Screen, line: str):
    if re.search(r'^rect', line):
        x, y = re.match(r'.* (\d+)x(\d+)', line).groups()
        screen.rect(int(x), int(y))
    else:
        i = int(re.search(r'=(\d+)', line).groups()[0])
        n = int(re.search(r'by (\d+)', line).groups()[0])

        if re.search(r'column', line):
            screen.rotCol(i, n)
        else:
            screen.rotRow(i, n)


screen = Screen()
for line in open("input/08.txt").readlines():
    move(screen, line.strip())

print(screen.sum())
print(screen.disp())
