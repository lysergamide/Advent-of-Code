import re
from itertools import permutations


def scramble(instructions, init='abcdefgh'):
    sneed = [c for c in init]

    for ins in instructions:
        if re.search(r'swap position', ins):
            i, j = re.match(r'.* (\d+) .* (\d+)', ins).groups()
            i = int(i)
            j = int(j)
            sneed[i], sneed[j] = sneed[j], sneed[i]

        elif re.search(r'swap letter', ins):
            x, y = re.match(r'.*letter (\w) with letter (\w).*', ins).groups()
            for i in range(len(sneed)):
                if sneed[i] == x:
                    sneed[i] = y
                elif sneed[i] == y:
                    sneed[i] = x

        elif re.search(r'rotate (left|right)', ins):
            i = int(re.match(r'.* (\d+)', ins)[1]) % len(sneed)
            if 'left' in ins:
                sneed = sneed[i:] + sneed[:i]
            else:
                sneed = sneed[-i:] + sneed[:-i]

        elif re.search(r'rotate', ins):
            c = re.search(r'.* (\w)$', ins)[1]
            i = sneed.index(c)
            i += 2 if i >= 4 else 1
            i %= len(sneed)
            sneed = sneed[-i:] + sneed[:-i]

        elif re.search(r'reverse', ins):
            i, j = re.match(r'.* (\d+) .* (\d+)', ins).groups()
            i = int(i)
            j = int(j)

            sneed = sneed[:i] + sneed[j:i-1 if i >
                                      0 else None:-1] + sneed[j + 1:]

        elif re.search(r'move', ins):
            i, j = re.match(r'.* (\d+) .* (\d+)', ins).groups()
            i = int(i)
            j = int(j)
            c = sneed[i]
            del sneed[i]
            sneed.insert(j, c)

    return ''.join(sneed)


# brute force
def unscramble(instructions, hashed='fbgdceah'):
    for p in permutations('abcdefgh'):
        if scramble(instructions, list(p)) == hashed:
            return ''.join(p)


lines = [line.strip() for line in open('input/21.txt').readlines()]
print(scramble(lines))
print(unscramble(lines))
