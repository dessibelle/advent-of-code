import re
from functools import reduce


class Transformation(object):

    def __init__(self, src, dst):
        self.src = src
        self.dst = dst
        self.src_regex = re.compile(self.src)
        self.dst_regex = re.compile(self.dst)

    def is_electron(self):
        return self.src == "e"

    def __str__(self):
        return "{} => {}".format(self.src, self.dst)

    def __repr__(self):
        return "{} => {}".format(self.src, self.dst)


class RedNosedReindeerNuclearFusionFissionPlant(object):

    def __init__(self, transformations):
        self.transformations = transformations

    def apply_transformation(self, transformation, molecule, reverse=False):
        regex = transformation.dst_regex if reverse else transformation.src_regex
        replace = transformation.src if reverse else transformation.dst

        it = regex.finditer(molecule)
        molecules = []

        for match in it:
            f, t = match.span()
            molecules.append(molecule[:f] + replace + molecule[t:])

        return molecules

    def calibrate(self, molecule, reverse=False):
        molecules = set()
        for t in self.transformations:
            molecules.update(self.apply_transformation(t, molecule, reverse=reverse))
        return molecules

    def find_molecule_path(self, target, current, path=[]):
        if target == current:
            return path

        if target not in current or len(target) == len(current):
            molecules = self.calibrate(current, reverse=True)

            shortest = reduce(lambda x, y: y if x is None or len(y) <= len(x) else x, molecules, None)

            return self.find_molecule_path(target, shortest, path + [shortest])


if __name__ == "__main__":

    repl_regex = re.compile(r'(?P<src>[A-Za-z]+)\s+=>\s+(?P<dst>[A-Za-z]+)')
    transformations = []
    electrons = []
    molecule = None

    with open("./day19.input.txt") as f:
        for line in f:
            line = line.strip()

            m = repl_regex.match(line)

            if m:
                t = Transformation(src=m.group('src'), dst=m.group('dst'))
                transformations.append(t)
                if t.is_electron():
                    electrons.append(t)

            elif len(line) > 0:
                molecule = line

    rrrnffp = RedNosedReindeerNuclearFusionFissionPlant(transformations)
    molecules = rrrnffp.calibrate(molecule)

    print("{} combinations".format(len(molecules)))

    # import sys
    # sys.setrecursionlimit(50)
    # molecule = "HOHOHO"

    path = rrrnffp.find_molecule_path("e", molecule)
    print("Found target {} in {} iterations".format(molecule, len(path)))
    for p in path:
        print(p)
