import re
import itertools
from operator import mul
from functools import reduce


class Ingredient(object):

    def __init__(self, name, **kwargs):
        self.name = name
        self.capacity = int(kwargs.get("capacity", 0))
        self.durability = int(kwargs.get("durability", 0))
        self.flavor = int(kwargs.get("flavor", 0))
        self.texture = int(kwargs.get("texture", 0))
        self.calories = int(kwargs.get("calories", 0))

    def scores(self, grams):
        return (
            self.capacity * grams,
            self.durability * grams,
            self.flavor * grams,
            self.texture * grams,
        )

    def __str__(self):
        return (
            "{name}: capacity {capacity}, durability {durability}, flavor "
            "{flavor}, texture {texture}, calories {calories}"
        ).format(**self.__dict__)


class Recipe(object):

    def __init__(self, ingredients, distribution):
        self.ingredients = ingredients
        self.distribution = distribution

        self._score = -1
        self._calories = -1

    def get_score(self):
        if self._score == -1:
            scores = []

            for ingredient, teaspoons in zip(self.ingredients, self.distribution):
                scores.append(ingredient.scores(teaspoons))

            self._score = reduce(mul, map(lambda x: max(x, 0), [sum(x) for x in zip(*scores)]))
        return self._score
    score = property(get_score)

    def get_calories(self):
        if self._calories == -1:
            self._calories = reduce(lambda x, y: x + y[0].calories * y[1], zip(self.ingredients, self.distribution), 0)
        return self._calories
    calories = property(get_calories)

    def __str__(self):
        o = ["Recipe", "=" * 20]
        for ingredient, teaspoons in zip(self.ingredients, self.distribution):
            o.append("{: >5} tsp {}".format(teaspoons, ingredient.name))

        o.append("")
        o.append("{: >9} points".format(self.score))
        o.append("{: >9} calories".format(self.calories))
        o.append("")

        return "\n".join(o)


def get_permutations(num):
    # return filter(lambda x: sum(x) == 100, itertools.product(range(101), repeat=num))
    return filter(lambda x: sum(x) == 100, itertools.product(range(1, 100 - num + 2), repeat=num))


if __name__ == "__main__":

    ing_regex = re.compile(
        r'(?P<name>[A-Za-z]+): capacity (?P<capacity>-?[0-9]+), durability (?P<durability>-?[0-9]+), '
        r'flavor (?P<flavor>-?[0-9]+), texture (?P<texture>-?[0-9]+), calories (?P<calories>-?[0-9]+)'
    )

    with open("./day15.input.txt") as f:

        ingredients = []
        for line in f:
            m = ing_regex.match(line.strip())

            ingredient = Ingredient(**m.groupdict())
            ingredients.append(ingredient)

        permutations = get_permutations(len(ingredients))

        best_recipe = None
        best_500kcal = None

        for p in permutations:
            r = Recipe(ingredients, p)

            if best_recipe is None or r.score > best_recipe.score:
                best_recipe = r

            if r.calories == 500 and r.score:
                if best_500kcal is None or r.score > best_500kcal.score:
                    best_500kcal = r

        for i in ingredients:
            print(i)

        print("")
        print(best_recipe)
        print(best_500kcal)
