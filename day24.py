import itertools
from functools import reduce


def product(l):
    return reduce(lambda x, y: x * y, l, 1)


class SledPackagingOptimzer(object):

    def __init__(self, packages, num_compartments=3):
        self.packages = set(packages)
        self.num_compartments = num_compartments
        self.compartment_weight = int(sum(packages) / num_compartments)

    def pick_optimal_first_group(self, groups=None):
        groups = groups or self.build_groups(packages)
        group = None

        for g in groups:
            if group is None or (len(g) <= len(group) and product(g) < product(group)):
                group = g

        return group

    def pack(self):
        groups = self.build_groups(packages)
        combinations = self.get_combinations(groups)
        combination = self.pick_optimal_combination(combinations)

        return combination

    def pick_optimal_combination(self, combinations, groups=None):
        first_group = self.pick_optimal_first_group(groups)

        for c in combinations:
            if c[0] == first_group:
                return c

    def get_combinations(self, groups):
        combinations = itertools.combinations(groups, r=self.num_compartments)

        packs = []
        for combination in combinations:
            combination_set = reduce(lambda x, y: x.update(set(y)) or x, combination, set())

            if combination_set == self.packages:
                packs.append(combination)

        return packs

    def build_groups(self, packages):
        groups = []
        for i in range(len(packages)):
            groups.extend(filter(
                lambda x: sum(x) == self.compartment_weight,
                itertools.combinations(optimizer.packages, r=i)
            ))

        return groups


if __name__ == "__main__":

    with open("./day24.input.txt") as f:

        packages = []
        for line in f:
            packages.append(int(line.strip()))

        optimizers = [
            SledPackagingOptimzer(packages),
            SledPackagingOptimzer(packages, num_compartments=4),
        ]

        for idx, optimizer in enumerate(optimizers):
            group = optimizer.pick_optimal_first_group()
            print("Optimal Quantum Entaglement for challenge {} is: {}".format(idx + 1, product(group)))

            # combination = optimizer.pack()
            # group = combination[0]
            # print("Optimal Quantum Entaglement for challenge {} is: {}".format(idx + 1, product(group)))
            # print(combination)
