import re


from Assembunny import Assembunny

bunny = Assembunny([line.strip() for line in open('input/12.txt').readlines()])
bunny.run()
print(bunny.reg[0])
bunny.clear()
bunny.reg[2] = 1
bunny.run()
print(bunny.reg[0])
