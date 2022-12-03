from collections import Counter


class Santa(object):

    def __init__(self, x=0, y=0):
        self.locations = Counter()
        self.set_location(x, y)

    def move(self, direction):
        x = self.x
        y = self.y

        if direction == '^':
            y += 1
        elif direction == '>':
            x += 1
        elif direction == 'v':
            y -= 1
        elif direction == '<':
            x -= 1

        self.set_location(x, y)

    def set_location(self, x, y):
        self.x = x
        self.y = y

        self.locations["{:d},{:d}".format(x, y)] += 1


def deliver_presents(directions):
    santa = Santa()

    for d in directions:
        santa.move(d)

    return santa.locations


def deliver_presents_distributed(directions):
    santas = [
        Santa(),
        Santa(),
    ]

    for idx, d in enumerate(directions):
        santa = santas[idx % 2]
        santa.move(d)

    locations = Counter()

    for s in santas:
        locations.update(s.locations)

    return locations


if __name__ == "__main__":

    with open("./day3.input.txt") as f:

        directions = f.read().strip()

        locations = deliver_presents(directions)
        distributed_locations = deliver_presents_distributed(directions)

        print("Locations visited Y1: ", len(locations.keys()))
        print("Locations visited Y2: ", len(distributed_locations.keys()))
