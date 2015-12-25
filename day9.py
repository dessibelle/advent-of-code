import re


class Vertex(object):

    def __init__(self, name):
        self.name = name
        self.edges = set()

    def add_neighbor(self, neighbor, distance):
        e1 = Edge(neighbor, distance)
        self.edges.add(e1)

        e2 = Edge(self, distance)
        neighbor.edges.add(e2)

    def __str__(self):
        edges = []
        for e in self.edges:
            d = e.distance
            v = e.vertex
            edges.append("{}: {}".format(v.name, d))

        return "{} ({})".format(self.name, ", ".join(edges))

    __unicode__ = __str__

    def __eq__(self, other):
        return self.name == other.name


class Edge(object):

    def __init__(self, vertex, distance):
        self.vertex = vertex
        self.distance = distance

    def __str__(self):
        return "-> {} - {}".format(self.vertex.name, self.distance)

    __unicode__ = __str__

    def __eq__(self, other):
        return self.distance == other.distance and self.vertex == other.vertex


class Graph(object):

    def __init__(self):
        self.vertices = {}

    def get_or_create_vertex(self, name):
        vertex = self.vertices.get(name)
        if not vertex:
            vertex = Vertex(name)
            self.vertices[name] = vertex
        return vertex

    def find_shortest_path(self, path=[], distance=0):
        edges = path[-1].edges if len(path) else map(lambda x: Edge(x, 0), self.vertices.values())

        # print("{}: {}".format(str(distance).rjust(5), [str(v.name) for v in path]))

        if len(path) == len(self.vertices):
            return path, distance

        shortest_path = None
        shortest_distance = 2 ** 63 - 1
        for e in edges:
            if e.vertex not in path:
                edge_path, edge_distance = self.find_shortest_path(path + [e.vertex], distance + e.distance)
                if edge_path and edge_distance < shortest_distance:
                    shortest_path = [] + edge_path
                    shortest_distance = edge_distance

        return shortest_path, shortest_distance

    def find_longest_path(self, path=[], distance=0):
        edges = path[-1].edges if len(path) else map(lambda x: Edge(x, 0), self.vertices.values())

        # print("{}: {}".format(str(distance).rjust(5), [str(v.name) for v in path]))

        if len(path) == len(self.vertices):
            return path, distance

        longest_path = None
        longest_distance = distance
        for e in edges:
            if e.vertex not in path:
                edge_path, edge_distance = self.find_longest_path(path + [e.vertex], distance + e.distance)
                if edge_path and longest_distance < edge_distance:
                    longest_path = [] + edge_path
                    longest_distance = edge_distance

        return longest_path, longest_distance


if __name__ == "__main__":

    graph = Graph()

    with open("./9.input.txt") as f:
        regex = re.compile(r'(?P<node>[A-Za-z]+)\s+to\s+(?P<destination>[A-Za-z]+)\s+=\s+(?P<distance>[0-9]+)')
        for line in f:
            m = regex.match(line.strip())

            nodename = m.group("node")
            destination = m.group("destination")

            node = graph.get_or_create_vertex(nodename)
            destination = graph.get_or_create_vertex(destination)
            distance = int(m.group("distance"))

            node.add_neighbor(destination, distance)

    path, distance = graph.find_shortest_path()
    print([str(p.name) for p in path] if path else None)
    print(distance)

    path, distance = graph.find_longest_path()
    print([str(p.name) for p in path] if path else None)
    print(distance)
