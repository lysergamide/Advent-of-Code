def findLowest(ranges):
    end = ranges[0][1] + 1
    i = 0
    while end >= ranges[i][0]:
        end = max(end, ranges[i][1] + 1)
        i += 1
    return end


def countValid(ranges):
    end = ranges[0][1] + 1
    ret = 0
    for r in ranges:
        if end < r[0]:
            ret += r[0] - end
            end = r[1] + 1
        else:
            end = max(end, r[1] + 1)
    return ret


ranges = [
    tuple(map(lambda x: int(x), line.strip().split('-'))) for line in open('input/20.txt').readlines()
]
ranges.sort()


print(findLowest(ranges))
print(countValid(ranges))
