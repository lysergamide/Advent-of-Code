from Assembunny import Assembunny as Bunny


# simply brute forcing works reasonably fast ¯\_(ツ)_/¯
def bunnySearch(bunny):
    def isLoop(i):
        count = 0
        bunny.reg[0] = i
        oldlen = 0

        while count < 8:
            newlen = len(bunny.outbuff)
            if oldlen == newlen or len(bunny.outbuff) < 2:
                pass
            elif bunny.outbuff[-1] == bunny.outbuff[-2]:
                bunny.clear()
                oldlen = newlen
                return False
            elif newlen > oldlen:
                count += 1
                oldlen = newlen

            bunny.step()
        bunny.clear()
        return True

    i = 0
    while True:
        if isLoop(i):
            return i
        i += 1


bunny = Bunny([line for line in open('./input/25.txt').readlines()])
print(bunnySearch(bunny))
