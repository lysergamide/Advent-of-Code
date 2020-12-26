from hashlib import md5
from queue import PriorityQueue


def pathfind(initCode):
    vault = [3, 3]
    origin = [0, 0]
    opened = 'bcdef'

    q = PriorityQueue()
    q.put((0,  initCode, origin))

    fastest = float('inf')
    password = ''

    while not q.empty():
        steps, code, pos = q.get()
        if steps >= fastest:
            continue
        elif pos == vault:
            fastest = steps
            password = code[len(initCode):]
            continue

        digest = md5(code.encode()).hexdigest()[:4]
        doors = [c in opened for c in digest]
        doors = [all(d) for d in zip(doors,
                                     [pos[0] > 0, pos[0] < 3, pos[1] > 0, pos[1] < 3])]

        for i, isOpen in enumerate(doors):
            if isOpen:
                nextChar = ['U', 'D', 'L', 'R'][i]
                nextPos = list(map(sum,
                                   zip(pos, [[-1, 0], [1, 0], [0, -1], [0, 1]][i])))
                nextCode = code + nextChar
                q.put((steps + 1,  nextCode, nextPos))

    return password


def wander(initCode):
    vault = [3, 3]
    origin = [0, 0]
    opened = 'bcdef'

    stack = []
    stack.append((0, initCode, origin))

    maxSteps = 0

    while len(stack) > 0:
        steps, code, pos = stack.pop()
        if pos == vault:
            maxSteps = max(maxSteps, steps)
            continue

        digest = md5(code.encode()).hexdigest()[:4]
        doors = [c in opened for c in digest]
        doors = [all(d) for d in zip(doors,
                                     [pos[0] > 0, pos[0] < 3, pos[1] > 0, pos[1] < 3])]

        for i, isOpen in enumerate(doors):
            if isOpen:
                nextChar = ['U', 'D', 'L', 'R'][i]
                nextPos = list(map(sum,
                                   zip(pos, [[-1, 0], [1, 0], [0, -1], [0, 1]][i])))
                nextCode = code + nextChar
                stack.append((steps + 1,  nextCode, nextPos))

    return maxSteps


sneed = open('input/17.txt').read().strip()
print(pathfind(sneed))
print(wander(sneed))
