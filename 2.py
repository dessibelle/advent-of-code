from functools import reduce
import re


def rrp_sides(sides):
    areas = []
    for a_idx, a in enumerate(sides):
        for b_idx, b in enumerate(sides):
            if a_idx != b_idx:
                areas.append(a * b)

    return areas


def rrp_areas(boxes):
    areas = []
    for box in boxes:
        sides = rrp_sides(box)
        areas.append(sum(sides) + min(sides))

    return areas


def rrp_area(boxes):
    return sum(rrp_areas(boxes))


def rrp_ribbon_length(sides):
    vol = reduce(lambda volume, side: volume * side, sides, 1)
    perimeter = (reduce(lambda volume, side: volume + side, sides, 0) - max(sides)) * 2

    return vol + perimeter


def rrp_ribbon_lengths(boxes):
    lengths = []
    for box in boxes:
        lengths.append(rrp_ribbon_length(box))
    return lengths


def rrp_ribbon_total(boxes):
    return sum(rrp_ribbon_lengths(boxes))


if __name__ == "__main__":

    numbers = re.compile(r'([0-9]+)')
    boxes = []

    with open("./2.input.txt") as f:

        for line in f:
            boxes.append(list(map(int, numbers.findall(line))))

    print("Wrapping:", rrp_area(boxes))
    print("Ribbon:", rrp_ribbon_total(boxes))
