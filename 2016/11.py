#!/usr/bin/env pypy3
from queue import Queue
from itertools import combinations
from functools import reduce

# sadly this is horribly slow
# part two clocked at ~37 minutes (2231.3470082 s)
# thats with pypy3...


def hasher(f):
    COLS = len(f[0])
    ret = 0
    pad = next((row.index(True) for row in f if any(row)))
    for row in f:
        for i in range(pad, pad + COLS):
            ret <<= 1
            ret |= row[i % COLS]

    return ret


def failure(f: list) -> bool:
    gen = any(f[1::2])
    loneChip = any((f[i] and not f[i - 1] for i in range(2, len(f), 2)))
    return loneChip and gen


def bfs(floors) -> int:
    COLS = len(floors[0])

    floors.reverse()
    q = Queue()
    q.put((0, 0, floors))
    seen = set([hasher(floors)])

    while not q.empty():
        steps, pos, state = q.get()

        if all(state[-1]):
            return steps

        nextPos = [i for i in [pos-1, pos+1] if i >= 0 and i < 4]
        nMoves = []
        for p in nextPos:
            nonempty = [i for i in range(1, COLS) if state[pos][i]]
            nMoves += (reduce(sum, [[[(p, [0, i])] for i in nonempty],
                                    [(p, [0] + list(comb)) for comb in combinations(nonempty, 2)]]))

        for nPos, move in nMoves:
            nState = [i[:] for i in state]

            for col in move:
                nState[pos][col], nState[nPos][col] = nState[nPos][col], nState[pos][col]

            h = hasher(nState)
            if h not in seen and not failure(nState[nPos]):
                q.put((steps + 1, nPos, nState))
                seen.add(h)


# hard coded inputs out of sheer laziness
part1 = [
    [False, False, False, False, False, False, False, False,
     False, False, False, False, False, False, False],
    [False, False, False, False, False, False, False, True,
     True, True, True, False, False, False, False],
    [False, False, False, False, True, False, True, False,
     False, False, False, False, False, False, False],
    [True, True, True, True, False, True, False, False,
     False, False, False, True, True, True, True]
]

part2 = [
    [False, False, False, False, False, False, False, False,
     False, False, False, False, False, False, False],
    [False, False, False, False, False, False, False, True,
        True, True, True, False, False, False, False],
    [False, False, False, False, True, False, True, False,
        False, False, False, False, False, False, False],
    [True, True, True, True, False, True, False, False,
        False, False, False, True, True, True, True]
]

print(bfs(part1))
print(bfs(part2))
