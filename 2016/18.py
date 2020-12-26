
def minesweep(start, rows=40):
    cols = len(start)
    safe = sum(start)
    field = [start] + [[True] * cols for _ in range(rows - 1)]

    for i in range(1, rows):
        for j in range(cols):
            l = j <= 0 or field[i - 1][j - 1]
            r = j >= (cols - 1) or field[i - 1][j + 1]
            res = (l or not r) and (not l or r)
            field[i][j] = res
            safe += field[i][j]

    return safe


start = [False if c == '^' else True for c in
         open("input/18.txt").read().strip()]

print(minesweep(start))
print(minesweep(start, 400000))
