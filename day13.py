import re
import itertools


class Guest(object):

    def __init__(self, name):
        self.name = name
        self.preferences = {}

    def add_preference(self, name, preference):
        self.preferences[name] = preference

    def preference_for(self, name):
        return self.preferences.get(name, 0)


class Party(object):

    def __init__(self):
        self.guests = {}

    def get_or_create_guest(self, name):
        g = self.guests.get(name)

        if g is None:
            g = Guest(name)
            self.guests[name] = g

        return g

    def get_seating_permutations(self):
        return itertools.permutations(self.guests)

    def calulate_seating_score(self, guests):
        score = 0
        num_guests = len(guests)

        for idx, g in enumerate(guests):
            guest = self.guests[g]
            neighbor_left = guests[idx + 1 if idx < num_guests - 1 else 0]
            neighbor_right = guests[idx - 1 if idx > 0 else num_guests - 1]
            preference_left = guest.preference_for(neighbor_left)
            preference_right = guest.preference_for(neighbor_right)

            score += preference_left + preference_right

        return score

    def optimize_seating(self):
        permutations = self.get_seating_permutations()
        best_score = -2 ** 63
        best_seating = None

        for p in permutations:
            score = self.calulate_seating_score(p)

            if score > best_score:
                best_score = score
                best_seating = p

        return best_score, best_seating


if __name__ == "__main__":

    party = Party()
    party2 = Party()
    guest = party2.get_or_create_guest("Simon")

    preference_regex = re.compile(r'(?P<object>[A-Za-z]+) would (?P<gainlose>[a-z]+) (?P<value>[0-9]+) happiness units by sitting next to (?P<subject>[A-Za-z]+)\.')

    with open("./13.input.txt") as f:

        for line in f:
            m = preference_regex.match(line.strip())

            guest_name = m.group('object')
            neighbor_name = m.group('subject')
            value = (int(m.group('gainlose') == "gain") * 2 + -1) * int(m.group('value'))

            guest = party.get_or_create_guest(guest_name)
            neighbor = party.get_or_create_guest(neighbor_name)
            guest.add_preference(neighbor.name, value)

            guest = party2.get_or_create_guest(guest_name)
            neighbor = party2.get_or_create_guest(neighbor_name)
            guest.add_preference(neighbor.name, value)

        score1, seating1 = party.optimize_seating()
        print("Best seating score: {}".format(score1))
        print(seating1)

        score2, seating2 = party2.optimize_seating()
        print("Best seating score: {}".format(score2))
        print(seating2)
