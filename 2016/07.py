#!/usr/bin/env python3
import regex as re


# regex...


def TLS(ip: str) -> bool:
    if re.search(r'\[[^\]]*(.)(.)(?!\1)(\2)(\1)[^\]]*\]', ip):
        return False

    return re.search(r'(.)(.)(?!\1)(\2)(\1)', ip)


def SSL(ip: str) -> bool:
    outer = re.sub(r'\[[^\]]*\]', ' ', ip)
    inner = ' '.join([x[1:-1] for x in re.findall(r'\[[^\]]*\]', ip)])
    matches = re.findall(r'(?=(.)(?!\1)(.)(\1))', outer)

    for match in matches:
        invert = match[1] + match[0] + match[1]
        if re.search(invert, inner):
            return True

    return False


lines = [line.strip() for line in open("input/07.txt").readlines()]

print(sum((1 for x in lines if TLS(x))))
print(sum((1 for x in lines if SSL(x))))
