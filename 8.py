if __name__ == "__main__":

    raw = 0
    parsed = 0
    escaped = 0
    with open("./8.input.txt") as f:
        for line in f:
            line = line.strip()
            raw += len(line)
            parsed += len(eval(line))
            escaped += len(line.replace("\\", "\\\\").replace('"', '\\"')) + 2

    print("{} - {} = {}".format(raw, parsed, raw - parsed))
    print("{} - {} = {}".format(escaped, raw, escaped - raw))
