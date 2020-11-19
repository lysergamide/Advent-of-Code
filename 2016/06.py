#!/usr/bin/env python3

import numpy as np

mat = []
for line in open("input/06.txt"):
    mat.append([x for x in line.strip()])
mat = np.array(mat).transpose().tolist()

print(''.join((max(col, key=lambda c: col.count(c)) for col in mat)))
print(''.join((max(col, key=lambda c: -col.count(c)) for col in mat)))
