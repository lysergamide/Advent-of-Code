from collections import deque


def josephus(n):
    return int(bin(n)[3:] + '1', 2)


def josephusRound(n):
    left = deque()
    right = deque()

    for i in range(1, n + 1):
        if i < n // 2 + 1:
            left.append(i)
        else:
            right.appendleft(i)
    while left and right:
        if len(left) > len(right):
            left.pop()
        else:
            right.pop()
        right.appendleft(left.popleft())
        left.append(right.pop())

    return left[0]


sneed = int(open('./input/19.txt').read())

print(josephus(sneed))
print(josephusRound(sneed))
