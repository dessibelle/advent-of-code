import itertools


def find_combinations(containers, target):
    combinations = []

    for i in range(1, len(containers) + 1):
        for x in itertools.combinations(containers, i):
            if sum(x) == target:
                combinations.append(x)

    return combinations


if __name__ == "__main__":

    with open("./day17.input.txt") as f:

        containers = []

        for l in f:
            containers.append(int(l.strip()))

        combinations = find_combinations(containers, 150)
        print("The number of ways to combine your {} different containers is {}.".format(
            len(containers),
            len(combinations)
        ))

        num_containers = list(map(lambda x: len(x), combinations))
        min_num = min(num_containers)
        print("Minimum number of containers is {}, with {} different combinations.".format(
            min_num,
            len(list(filter(lambda x: x == min_num, num_containers)))
        ))
