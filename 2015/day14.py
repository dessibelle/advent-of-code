import re


class Raindeer(object):

    def __init__(self, name, speed, burst, rest):
        self.name = name
        self.speed = int(speed)
        self.burst = int(burst)
        self.rest = int(rest)

    def get_period(self):
        return self.burst + self.rest
    period = property(get_period)

    def distance_in_seconds(self, seconds):
        num_bursts = seconds // self.period
        num_seconds = self.burst * num_bursts
        remainder = seconds % self.period
        num_seconds += remainder if remainder < self.burst else self.burst

        return self.speed * num_seconds

        return int(round(self.speed * self.burst * self.num_bursts_in_seconds(seconds)))


if __name__ == "__main__":

    rd_regex = re.compile(r'(?P<name>[A-Za-z]+) can fly (?P<speed>[0-9]+) km/s for (?P<burst>[0-9]+) seconds, but then must rest for (?P<rest>[0-9]+) seconds\.')

    with open("./day14.input.txt") as f:

        raindeer = []
        for line in f:
            m = rd_regex.match(line.strip())
            raindeer.append(Raindeer(m.group("name"), m.group("speed"), m.group("burst"), m.group("rest")))

        sec = 2503
        top_raindeer = None
        for r in raindeer:
            if top_raindeer is None or r.distance_in_seconds(sec) > top_raindeer.distance_in_seconds(sec):
                top_raindeer = r

        print("{}: {}".format(top_raindeer.name, top_raindeer.distance_in_seconds(sec)))

        scoreboard = dict(zip(map(lambda x: x.name, raindeer), [0] * len(raindeer)))
        for x in range(1, sec + 1):
            distances = {}

            for r in raindeer:
                distances[r.name] = r.distance_in_seconds(x)

            highest = max(distances.values())
            for k, v in distances.items():
                if v == highest:
                    scoreboard[k] += 1

        print("Winner: {}, {}".format(max(scoreboard), max(scoreboard.values())))
