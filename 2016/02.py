pad = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

pad2 = [
    [None, None, 0x1, None, None],
    [None, 2, 3, 4, None],
    [5, 6, 7, 8, 9],
    [None, 0xA, 0xB, 0xC, None],
    [None, None, 0xD, None, None, ]
]


def solve(pad, moves, pos):
    ret = list()
    for move in moves:
        for step in move:
            i, j = pos
            if step == "U":
                if i > 0 and pad[i - 1][j] is not None:
                    pos[0] -= 1
            elif step == "D":
                if i < len(pad) - 1 and pad[i + 1][j] is not None:
                    pos[0] += 1
            elif step == "L":
                if j > 0 and pad[i][j - 1] is not None:
                    pos[1] -= 1
            elif step == "R":
                if j < len(pad[i]) - 1 and pad[i][j + 1] is not None:
                    pos[1] += 1

        ret.append(pad[pos[0]][pos[1]])
    return ret


def toStr(arr):
    return ''.join([f'{x:X}' for x in arr])


lines = [x.strip() for x in open("input/02.txt").readlines()]
part1 = toStr(solve(pad, lines, [1, 1]))
part2 = toStr(solve(pad2, lines, [2, 2]))

print(part1)
print(part2)
