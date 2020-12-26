from functools import reduce
from operator import mul
import re

# assembunny instructions turn out to be factorial(n) + c * d from end of input


def factorial(n): return reduce(mul, range(1, n+1))


lines = [line.strip() for line in open('input/23.txt').readlines()]
a, b = lines[-6], lines[-7]
a = int(re.search(r'\d+', a)[0])
b = int(re.search(r'\d+', b)[0])


for i in [7, 12]:
    print(factorial(i) + a * b)
