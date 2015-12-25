import json


def object_sum(data, exclude=[], total=0):
    if isinstance(data, (int, float,)):
        return total + data
    elif isinstance(data, list):
        lt = 0
        for d in data:
            lt += object_sum(d, exclude, total)
        return lt
    elif isinstance(data, dict):
        dt = 0
        for k, v in data.items():
            if v in exclude:
                return total
            dt += object_sum(v, exclude, total)
        return dt
    return 0


if __name__ == "__main__":

    with open("./12.input.txt") as f:
        data = json.loads(f.read())

        print object_sum(data)
        print object_sum(data, ["red"])
