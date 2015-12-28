import random
import re
from collections import defaultdict
import itertools
from functools import reduce
from day21 import Fight, PlayingCharacter, DeathException, Character, load_opponent
import operator


DEBUG = False


class Spell(object):

    def __init__(self, name, cost, **kwargs):
        self.name = name
        self.cost = int(cost)
        self.damage = int(kwargs.get('damage', 0))
        self.points = int(kwargs.get('points', 0))
        self.turns = int(kwargs.get('turns', -1))
        self.armor = int(kwargs.get('armor', 0))
        self.mana = int(kwargs.get('mana', 0))

    def get_is_effect(self):
        return self.turns > 0
    is_effect = property(get_is_effect)

    def apply(self, wizard, opponent):
        if self.is_effect:
            if self.mana:
                wizard.mana += self.mana

            if self.damage:
                opponent.take_hit(wizard, self.damage)
        else:
            opponent.take_hit(self, self.damage)
            wizard.points += self.points

            if DEBUG:
                print("{} deals {}, dealing {} damage.".format(wizard.name, self.name, self.damage))

    def get_compound_score_and_cost(self, turns=None):
        turns = turns or max(self.turns, 1)

        score = turns * (self.damage + self.points + self.armor)
        cost = self.cost / turns - self.mana * turns

        return score, cost

    def get_compound_cost(self, turns=None):
        score, cost = self.get_compound_score_and_cost(turns)
        return cost

    def get_compound_score(self, turns=None):
        score, cost = self.get_compound_score_and_cost(turns)
        return score

    def __lt__(self, other):
        self.get_compound_cost() < other.get_compound_cost()

    def __le__(self, other):
        self.get_compound_cost() <= other.get_compound_cost()

    def __eq__(self, other):
        self.get_compound_cost() == other.get_compound_cost()

    def __ne__(self, other):
        self.get_compound_cost() != other.get_compound_cost()

    def __gt__(self, other):
        self.get_compound_cost() > other.get_compound_cost()

    def __ge__(self, other):
        self.get_compound_cost() >= other.get_compound_cost()

    def __hash__(self):
        return hash(self.name)

    def __str__(self):
        keys = ["damage", "points", "armor", "mana"]
        properties = []
        for i in keys:
            if hasattr(self, i) and getattr(self, i):
                properties.append("{} {}".format(i, getattr(self, i)))

        return "{} with cost {} ({})".format(
            "Effect, {} turn,".format(self.turns) if self.is_effect else "Spell",
            self.cost,
            ", ".join(properties)
        )

    def __repr__(self):
        return str(self)


class EffectWoreOffException(Exception):

    def __init__(self, effect, wizard, opponent, *args, **kwargs):
        super(Exception, self).__init__(*args, **kwargs)


class Effect(object):

    def __init__(self, spell):
        self.spell = spell
        self.turns_left = spell.turns

    def apply(self, wizard, opponent):
        self.spell.apply(wizard, opponent)
        self.turns_left -= 1

        if DEBUG:
            print("{} deals {} damage; its timer is now {}.".format(
                self.spell.name,
                3,
                self.turns_left
            ))

        if self.turns_left < 1:
            raise EffectWoreOffException(self, wizard, opponent)

    def get_compound_score_and_cost(self, turns=None):
        return self.spell.get_compound_score_and_cost(self.turns_left)

    def get_compound_cost(self, turns=None):
        return self.spell.get_compound_cost(self.turns_left)

    def get_compound_score(self, turns=None):
        return self.spell.get_compound_score(self.turns_left)

    def __eq__(self, other):
        return self.spell.name == other.spell.name

    def __hash__(self):
        return hash(self.spell.name)


class Spellbook(object):

    def __init__(self, spells=[]):
        self.spells = {s.name: s for s in spells}
        self.instants = {s.name: s for s in filter(lambda x: not x.is_effect, spells)}
        self.effects = {s.name: s for s in filter(lambda x: x.is_effect, spells)}

    def get_spells(self):
        return self.spells.values()

    def get_instants(self):
        return self.instants.values()

    def get_effects(self):
        return self.effects.values()

    def __str__(self):
        return "\n".join([str(s) for s in self.get_spells()])

    def __repr__(self):
        return str(self)


class Wizard(PlayingCharacter):

    def __init__(self, spellbook, name="Mighty Wizard", mana=500, points=50, **kwargs):
        kwargs.update(points=points)
        super(Wizard, self).__init__(name=name, **kwargs)
        self.spellbook = spellbook
        self.effects = set()
        self.mana = mana
        self.mana_spending = 0
        self.spell_count = -1

    def apply_effects(self, opponent):
        items_to_remove = set()

        for effect in self.effects:
            try:
                # if DEBUG:
                #     print("{} applying {} ({})".format(
                #         self.name,
                #         effect.spell.name,
                #         effect.turns_left
                #     ))

                effect.apply(self, opponent)
            except EffectWoreOffException as e:
                items_to_remove.add(effect)

        self.effects.difference_update(items_to_remove)

    def _print_turn_notice(self, turntaker, opponent):
        if DEBUG:
            print("")
            print("-- {} turn --".format(turntaker.name))
            print("- {} has {} hit points, {} armor, {} mana -".format(
                self.name, self.points, self.get_armor(), self.mana
            ))
            print("- {} has {} hit points".format(
                opponent.name, opponent.points
            ))

    def hard_mode_attack(self, attacker, opponent):
        opponent.points -= 1
        if opponent.points < 0:
            raise DeathException(attacker, opponent)

    def attack(self, opponent):
        self.hard_mode_attack(opponent, self)

        self._print_turn_notice(self, opponent)

        self.apply_effects(opponent)
        spell = self.pick_spell(opponent)

        if spell is None:
            raise DeathException(opponent, self)

        self.mana -= spell.cost
        self.mana_spending += spell.cost

        if DEBUG and spell.is_effect:
            print("{} casts {}.".format(self.name, spell.name))

        if spell.is_effect:
            self.effects.add(Effect(spell))
        else:
            spell.apply(self, opponent)

    def take_hit(self, attacker, score):
        self._print_turn_notice(attacker, attacker)

        self.apply_effects(attacker)
        if attacker.points > 0:
            if DEBUG:
                print("{} attacks for {} damage.".format(attacker.name, score))
            self.points -= score

    def get_armor(self):
        return reduce(lambda x, y: x + y.spell.armor if y.spell.is_effect else 0, self.effects, self.armor)

    def effect_score(self):
        score = 0
        turns = 0
        for e in self.effects:
            score += e.get_compound_score(e.turns_left)
            turns = max(turns, e.turns_left)
        return score, turns

    def pick_spell(self, opponent):
        self.spell_count += 1

        available_spells = set(spellbook.get_spells()) - set([e.spell for e in self.effects])
        spells = list(filter(lambda e: e.cost < self.mana, available_spells))

        if len(spells):
            return random.choice(spells)

        return None

    # def pick_spell(self, opponent):
    #     self.spell_count += 1
    #     spell = None

    #     effect_score, effect_turns = self.effect_score()
    #     winning_spells = []

    #     for s in self.spellbook.get_spells():
    #         if not self.has_spell(s):
    #             score, cost = s.get_compound_score_and_cost()

    #             if effect_score + score > opponent.points + opponent.damage * effect_turns:
    #                 winning_spells.append(s)
    #             elif (spell is None or cost < spell.get_compound_cost()):
    #                 spell = s

    #     if len(winning_spells):
    #         return min(winning_spells)

    #     return spell

    # def pick_spell(self, opponent):
    #     return reduce(
    #         lambda x, y: y if not self.has_spell(y) and (x is None or y.cost > x.cost) else x,
    #         self.spellbook.get_spells(),
    #         None
    #     )

    def has_spell(self, spell):
        return Effect(spell) in self.effects


if __name__ == "__main__":

    spells = [
        Spell("Magic Missile", cost=53, damage=4),
        Spell("Drain", cost=73, damage=2, points=2),
        Spell("Shield", cost=113, turns=6, armor=7),
        Spell("Poison", cost=173, turns=6, damage=3),
        Spell("Recharge", cost=229, turns=5, mana=101),
    ]

    spellbook = Spellbook(spells)

    # wizard = Wizard(name="Player", mana=250, points=10, spellbook=spellbook)
    # boss = Character(name="Boss", points=14, damage=8)

    # wizard = Wizard(spellbook=spellbook)
    # boss = load_opponent("./day22.input.txt")

    # fight = Fight([wizard, boss])

    # try:
    #     fight.start()
    # except DeathException as e:

    #     print("{} won against {}{}.".format(e.attacker, e.defender, " with spending {}".format(e.attacker.mana_spending) if not e.is_npc_win else ""))

    best_score = 2 ** 63 - 1
    for i in range(0, 10000):
        wizard = Wizard(spellbook=spellbook)
        boss = load_opponent("./day22.input.txt")

        fight = Fight([wizard, boss])

        try:
            fight.start()
        except DeathException as e:

            print("{} won against {}{}.".format(e.attacker, e.defender, " with spending {}".format(e.attacker.mana_spending) if not e.is_npc_win else ""))

            if not e.is_npc_win:
                best_score = min(best_score, e.attacker.mana_spending)

    print(best_score)
