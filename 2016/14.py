from hashlib import md5
import re


def search(salt: str, stretch=0) -> int:

    i = 0
    indicies = []
    hashes = []

    while True:
        attempt = salt + str(i)
        result = md5(attempt.encode()).hexdigest()
        for _ in range(stretch):
            result = md5(result.encode()).hexdigest()

        hashes.append(result)

        quint = re.search(r'(.)\1{4}', result)
        if quint:
            key = quint[0][0] * 3
            for j in range(max(0, i - 1000), i):
                trip = re.search(r'(.)\1{2}', hashes[j])
                if trip and trip[0] == key:
                    indicies.append(j)
                    indicies = list(set(indicies))

                    if len(indicies) >= 64:
                        indicies.sort()
                        return indicies[63]
        i += 1

salt = open("./input/14.txt").read().strip()

print(search(salt))
print(search(salt, 2016))
