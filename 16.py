import re
import operator


class Aunt(object):

    def __init__(self, identifier, **kwargs):
        self.identifier = identifier
        self.children = kwargs.get("children")
        self.cats = kwargs.get("cats")
        self.samoyeds = kwargs.get("samoyeds")
        self.pomeranians = kwargs.get("pomeranians")
        self.akitas = kwargs.get("akitas")
        self.vizslas = kwargs.get("vizslas")
        self.goldfish = kwargs.get("goldfish")
        self.trees = kwargs.get("trees")
        self.cars = kwargs.get("cars")
        self.perfumes = kwargs.get("perfumes")

    def matches(self, **kwargs):
        match = True
        for key, value in kwargs.items():
            attr = getattr(self, key)
            match &= attr is None or attr == value

        return match

    def matches_retroencabulator(self, **kwargs):
        match = True
        for key, value in kwargs.items():
            attr = getattr(self, key)
            op = operator.eq
            if key in ("cats", "trees"):
                op = operator.gt
            elif key in ("pomeranians", "goldfish"):
                op = operator.lt

            match &= attr is None or op(attr, value)

        return match

    def __str__(self):
        return "Sue {}".format(self.identifier)


if __name__ == "__main__":

    prop_regex = re.compile(r'([a-z]+):\s+([0-9]+)+')
    sue_regex = re.compile(r'Sue\s+([0-9]+):')

    with open("./16.input.txt") as f:

        target = {
            "children": 3,
            "cats": 7,
            "samoyeds": 2,
            "pomeranians": 3,
            "akitas": 0,
            "vizslas": 0,
            "goldfish": 5,
            "trees": 3,
            "cars": 2,
            "perfumes": 1,
        }

        aunts = []
        aunts_retroencabulator = []
        for l in f:
            line = l.strip()
            identifier = int(sue_regex.findall(line).pop())
            properties = {k: int(v) for k, v in prop_regex.findall(line)}

            a = Aunt(identifier=identifier, **properties)
            if a.matches(**target):
                aunts.append(a)

            if a.matches_retroencabulator(**target):
                aunts_retroencabulator.append(a)

        print([str(aunt) for aunt in aunts])
        print([str(aunt) for aunt in aunts_retroencabulator])
