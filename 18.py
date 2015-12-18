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
        neighbors_sum = np.sum(s) - int(status)

        # for i in range(max(0, x - 1), min(x + 2, len(self.grid))):
        #     for j in range(max(0, y - 1), min(y + 2, len(self.grid[i]))):
        #         neighbors_sum += self.grid[i, j] if (i, j) != (x, y) else 0

        return (status and neighbors_sum not in (2, 3)) or (not status and neighbors_sum == 3)

    def toggle(self):
        pixels = []

        for i in range(0, len(self.grid)):
            for j in range(0, len(self.grid[i])):
                if self.should_toggle(i, j):
                    pixels.append((i, j))

        for x, y in pixels:
            self.grid[x, y] = not self.grid[x, y]

    def sum(self):
        return np.sum(self.grid)

    def __str__(self):
        rows = []

        for i in range(0, len(self.grid)):
            row = ""
            for j in range(0, len(self.grid[i])):
                row += "#" if self.grid[i, j] == True else "."
            rows.append(row)

        return "\n".join(rows)


class CorneredGrid(Grid):

    def should_toggle(self, x, y):
        if (x, y,) in ((0, 0,), (0, len(self.grid) - 1,), (len(self.grid) - 1, 0,), (len(self.grid) - 1, len(self.grid) - 1,),):
            return False

        return super(CorneredGrid, self).should_toggle(x, y)

    def toggle(self):
        self.grid[0, 0] = True
        self.grid[0, len(self.grid) - 1] = True
        self.grid[len(self.grid) - 1, 0] = True
        self.grid[len(self.grid) - 1, len(self.grid) - 1] = True
        super(CorneredGrid, self).toggle()


if __name__ == "__main__":

    steps = 100

    with open("./18.input.txt") as f:
        width = 0
        height = 0

        rows = []
        for line in f:
            line = line.strip()
            rows.append(line)
            width = max(width, len(line))

        height = len(rows)

        grid = Grid(width, height)
        cgrid = CorneredGrid(width, height)

        for x, row in enumerate(rows):
            for y, c in enumerate(row):
                grid.grid[x, y] = True if c == '#' else False
                cgrid.grid[x, y] = True if c == '#' else False

        for i in range(steps):
            grid.toggle()
            cgrid.toggle()

        print("\n" + str(grid) + "\n\n=====")
        print(grid.sum())

        print("\n" + str(cgrid) + "\n\n=====")
        print(cgrid.sum())


