import numpy as np
import re


class Grid(object):

    TYPE = np.bool_

    def __init__(self, width, height):
        self.grid = np.zeros((width, height,), dtype=self.TYPE)

    @staticmethod
    def _get_coords(from_coord, to_coord):
        fx, fy = from_coord
        tx, ty = to_coord

        return fx, tx + 1, fy, ty + 1

    def turnOn(self, from_coord, to_coord):
        fx, tx, fy, ty = self._get_coords(from_coord, to_coord)

        self.grid[fx:tx, fy:ty] = True

    def turnOff(self, from_coord, to_coord):
        fx, tx, fy, ty = self._get_coords(from_coord, to_coord)

        self.grid[fx:tx, fy:ty] = False

    def toggle(self, from_coord, to_coord):
        fx, tx, fy, ty = self._get_coords(from_coord, to_coord)

        self.grid[fx:tx, fy:ty] = np.invert(self.grid[fx:tx, fy:ty])

    def sum(self):
        return np.sum(self.grid)


class DimmableGrid(Grid):

    TYPE = np.int8

    def turnOn(self, from_coord, to_coord):
        fx, tx, fy, ty = self._get_coords(from_coord, to_coord)

        self.grid[fx:tx, fy:ty] += 1

    def turnOff(self, from_coord, to_coord):
        fx, tx, fy, ty = self._get_coords(from_coord, to_coord)

        self.grid[fx:tx, fy:ty] -= 1
        self.grid[self.grid < 0] = 0

    def toggle(self, from_coord, to_coord):
        fx, tx, fy, ty = self._get_coords(from_coord, to_coord)

        self.grid[fx:tx, fy:ty] += 2


class FileParser(object):

    def __init__(self, path, grid):
        self.path = path
        self.grid = grid

        self.line_regex = re.compile(r'(?P<method>[a-z]+(\s+[a-z]+)?)\s+(?P<fx>[0-9]+),(?P<fy>[0-9]+)\s+[a-z]+\s+(?P<tx>[0-9]+),(?P<ty>[0-9]+)')

        self.methods = {
            "turn on": grid.turnOn,
            "turn off": grid.turnOff,
            "toggle": grid.toggle,
        }

    def transform_grid(self, method_name, fx, fy, tx, ty):
        method = self.methods.get(method_name)

        if callable(method):
            method((fx, fy), (tx, ty))

    def parse(self):
        with open(self.path) as f:
            for line in f:
                parse_result = self.parse_line(line)
                self.transform_grid(*parse_result)

    def parse_line(self, line):
        line = line.strip()
        m = self.line_regex.match(line)

        return m.group("method"), int(m.group("fx")), int(m.group("fy")), int(m.group("tx")), int(m.group("ty"))


if __name__ == "__main__":

    grid = Grid(1000, 1000)
    parser = FileParser("./day6.input.txt", grid)
    parser.parse()
    print(grid.sum())

    grid = DimmableGrid(1000, 1000)
    parser = FileParser("./day6.input.txt", grid)
    parser.parse()
    print(grid.sum())
