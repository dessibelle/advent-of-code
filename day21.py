import re
from collections import defaultdict
import itertools


cat_regex = re.compile(r'(?P<name>[A-Za-z]+):\s+[A-Za-z]+\s+[A-Za-z]+\s+[A-Za-z]+')
item_regex = re.compile(r'(?P<name>[A-Za-z]+(\s+\+\d+)?)\s+(?P<cost>[0-9]+)\s+(?P<damage>[0-9]+)\s+(?P<armor>[0-9]+)')

points_regex = re.compile(r'Hit Points: (?P<points>\d+)')
damage_regex = re.compile(r'Damage: (?P<damage>\d+)')
armor_regex = re.compile(r'Armor: (?P<armor>\d+)')


class DeathException(Exception):

    def __init__(self, attacker, defender, *args, **kwargs):
        super(Exception, self).__init__(*args, **kwargs)
        self.attacker = attacker
        self.defender = defender
        self.is_npc_win = self.attacker.is_npc

    def __str__(self):
        if self.is_npc_win:
            return "{} was killed by {}".format(self.defender.name, self.attacker.name)

        return "{} killed {}".format(self.attacker.name, self.defender.name)

    def __repr__(self):
        return str(self)


class Fight(object):

    def __init__(self, players):
        self.players = players
        self.turn = -1

    def next_turn(self):
        self.turn += 1

        attacker = self.players[self.turn % len(self.players)]
        defender = self.players[(self.turn + 1) % len(self.players)]

        attacker.attack(defender)

        if defender.points < 1:
            raise DeathException(attacker, defender)

    def reset(self):
        for p in self.players:
            p.reset()

    def start(self):
        self.reset()

        while True:
            self.next_turn()


class Character(object):

    def __init__(self, name, points=100, damage=0, armor=0):
        self.name = name
        self.initial_points = int(points)
        self.damage = int(damage)
        self.armor = int(armor)
        self.is_npc = True
        self.reset()

    def reset(self):
        self.points = self.initial_points

    def attack(self, opponent):
        score = max(self.get_damage() - opponent.get_armor(), 1)
        opponent.take_hit(score)

        # print("{} attacked {} with score {:>3}, resulting in opponent points {:>3}".format(
        #     self.name,
        #     opponent.name,
        #     score,
        #     opponent.points
        # ))

    def take_hit(self, score):
        self.points -= score

    def get_damage(self):
        return self.damage

    def get_armor(self):
        return self.armor

    def __str__(self):
        return "{}, {}p (Damage: {}, Armor: {})".format(self.name, self.points, self.get_damage(), self.get_armor())

    def __repr__(self):
        return str(self)


class Player(Character):

    def __init__(self, name="Player 1", items=[], **kwargs):
        kwargs.update(damage=0, armor=0)
        super(Player, self).__init__(name=name, **kwargs)
        self.items = items
        self._reset_damage_and_armor()
        self.is_npc = False

    def _reset_damage_and_armor(self):
        self._damage = None
        self._armor = None

    def buy_item(self, item):
        self.items.append(item)
        self._reset_damage_and_armor()

    def set_items(self, items):
        self.items = items
        self._reset_damage_and_armor()

    def get_item_cost(self):
        return reduce(lambda x, y: x + y.cost, self.items, 0)
    item_cost = property(get_item_cost)

    def get_damage(self):
        if self._damage is None:
            self._damage = self.damage + reduce(lambda x, y: x + y.damage, self.items, 0)
        return self._damage

    def get_armor(self):
        if self._armor is None:
            self._armor = self.armor + reduce(lambda x, y: x + y.armor, self.items, 0)
        return self._armor


class Item(object):

    def __init__(self, **kwargs):
        self.name = kwargs.get('name')
        self.cost = int(kwargs.get('cost'))
        self.damage = int(kwargs.get('damage'))
        self.armor = int(kwargs.get('armor'))
        self.category = kwargs.get('category')

    def __str__(self):
        return "{:15}{:7}{:7}{:7}".format(
            self.name,
            self.cost,
            self.damage,
            self.armor
        )

    def __repr__(self):
        return self.name


class Shop(object):

    def __init__(self, items=[]):
        self.items = defaultdict(list)
        for item in items:
            self.add_item(item)

    def add_item(self, item):
        self.items[item.category].append(item)

    def get_combinations(self):
        weapons = self.items["Weapons"]
        armor = self.items["Armor"]
        rings = self.items["Rings"]

        combinations = []
        combinations.extend(itertools.product(*[weapons]))
        combinations.extend(itertools.product(*[weapons, armor]))
        combinations.extend(itertools.product(*[weapons, armor, rings]))
        combinations.extend(itertools.product(*[weapons, armor, rings, rings]))
        combinations.extend(itertools.product(*[weapons, rings]))
        combinations.extend(itertools.product(*[weapons, rings, rings]))

        return combinations

    def __str__(self):
        out = []
        for c, items in self.items.items():
            out.append("{:16} {:>5}{:>7}{:>7}".format("== " + c + " ==", "Cost", "Damage", "Armor"))
            for item in items:
                out.append(str(item))
            out.append("")

        return "\n".join(out)

    def __repr__(self):
        return str(self)


def load_items(path):
    shop = Shop()

    with open(path) as f:
        category = None

        for line in f:
            line = line.strip()

            c = cat_regex.match(line)
            i = item_regex.match(line)

            if c:
                category = c.group('name')
            elif i:
                item = Item(category=category, **i.groupdict())
                shop.add_item(item)

    return shop


def load_opponent(path):

    with open(path) as f:
        kwargs = {
            "name": "Boss",
        }

        for line in f:
            p = points_regex.match(line)
            d = damage_regex.match(line)
            a = armor_regex.match(line)

            kwargs.update(p.groupdict() if p else {})
            kwargs.update(d.groupdict() if d else {})
            kwargs.update(a.groupdict() if a else {})

    return Character(**kwargs)


if __name__ == "__main__":

    shop = load_items("./21.items.txt")
    boss = load_opponent("./21.input.txt")
    player = Player()

    print(shop)

    combinations = shop.get_combinations()
    min_cost = 2 ** 63 - 1
    max_cost = 0
    best_items = []
    worst_items = []

    for c in combinations:
        player.set_items(list(c))
        fight = Fight([player, boss])

        # print("### Fight with items: {} ###\n".format(", ".join([i.name for i in c])))
        # print(boss)
        # f = "{:>" + str(max(len(str(boss)), len(str(player))) // 2) + "}"
        # print(f.format("vs."))
        # print(player)
        # print("\nFIGHT!\n")

        try:
            fight.start()
        except DeathException as e:

            # print("\n{} won{}.\n".format(e.attacker, " with spending {}".format(e.attacker.get_item_cost()) if not e.is_npc_win else ""))

            if not e.is_npc_win:
                if min_cost != min(min_cost, e.attacker.get_item_cost()):
                    best_items = e.attacker.items
                min_cost = min(min_cost, e.attacker.get_item_cost())
            else:
                if max_cost != max(max_cost, e.defender.get_item_cost()):
                    worst_items = e.defender.items
                max_cost = max(max_cost, e.defender.get_item_cost())

    print("Optimal winning item cost: {}, for items:".format(min_cost))
    for i in best_items:
        print(i)

    print("\nHighest losing item cost: {}, for items:".format(max_cost))
    for i in worst_items:
        print(i)
