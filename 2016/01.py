# closest thing to an enum
class Ord:
    north = 0
    east = 1
    south = 2
    west = 3


class Position:
    def __init__(self):
        self.dir = Ord.north
        self.pos = [0, 0]
        self.visited = set((tuple(self.pos)))
        self.found = False

    def turnLeft(self):
        self.dir = self.dir - 1 if self.dir > 0 else Ord.west

    def turnRight(self):
        self.dir = (self.dir + 1) % (Ord.west + 1)

    def move(self, x: int):
        for _ in range(x):
            if self.dir == Ord.north:
                self.pos[0] += 1
            elif self.dir == Ord.east:
                self.pos[1] += 1
            elif self.dir == Ord.south:
                self.pos[0] -= 1
            elif self.dir == Ord.west:
                self.pos[1] -= 1

            if not self.found:
                if tuple(self.pos) in self.visited:
                    self.dupe = self.pos.copy()
                    self.found = True
                else:
                    self.visited.add(tuple(self.pos))


santa = Position()
file = open("./input/01.txt").read().strip()

for inst in file.split(","):
    inst = inst.strip()
    d = inst[:1]
    x = int(inst[1:])
    if d == 'L':
        santa.turnLeft()
    elif d == 'R':
        santa.turnRight()

    santa.move(int(x))


print(sum(map(lambda x: abs(x), santa.pos)))
print(sum(map(lambda x: abs(x), santa.dupe)))
