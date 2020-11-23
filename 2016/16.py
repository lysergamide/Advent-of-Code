import string
# easy one

def dragon(a, length):
    while len(a) < length:
        a = a + '0' + a[::-1].translate(str.maketrans('10', '01'))

    return a


def checksum(drag, length):
    checksum = drag[:length]
    while True:
        checksum = ''.join(map(lambda x: '1' if x[0] == x[1] else '0',
                               zip(checksum[::2], checksum[1::2])))
        if len(checksum) % 2 == 1:
            break

    return checksum


sneed = open("./input/16.txt").read().strip()

print(checksum(dragon(sneed, 272), 272))
print(checksum(dragon(sneed, 35651584), 35651584))
