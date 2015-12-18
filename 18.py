import numpy as np


class Grid(object):

    TYPE = np.bool_

    def __init__(self, width, height):
        self.grid = np.zeros((width, height,), dtype=self.TYPE)

    def should_toggle(self, x, y):
        status = self.grid[x, y]

        fx = max(0, x - 1)
        tx = min(x + 2, len(self.grid))
        fy = max(0, y - 1)
        ty = min(y + 2, len(self.grid[0]))

        s = self.grid[fx:tx, fy:ty]
        neighbors_sum = np.sum(s)

        # for i in range(max(0, x - 1), min(x + 2, len(self.grid))):
        #     for j in range(max(0, y - 1), min(y + 2, len(self.grid[i]))):
        #         neighbors_sum += self.grid[i, j] if (i, j) != (x, y) else 0

        return (status and neighbors_sum in (2, 3)) or (not status and neighbors_sum == 3)

    def toggle(self):
        pixels = []

        for i in range(0, len(self.grid)):
            for j in range(0, len(self.grid[i])):
                if self.should_toggle(i, j):
                    pixels.append((i, j))

        print(pixels)

        for x, y in pixels:
            self.grid[x, y] = not self.grid[x, y]

    def sum(self):
        return np.sum(self.grid)


if __name__ == "__main__":

    with open("./18.test.txt") as f:
        width = 0
        height = 0

        rows = []
        for line in f:
            line = line.strip()
            rows.append(line)
            width = max(width, len(line))

        height = len(rows)

        grid = Grid(width, height)

        for x, row in enumerate(rows):
            for y, c in enumerate(row):
                grid.grid[x, y] = True if c == '#' else False

        print(grid.sum())

        grid.toggle()
        grid.toggle()
        grid.toggle()
        grid.toggle()
        grid.toggle()

        print(grid.sum())
