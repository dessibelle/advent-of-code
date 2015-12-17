if __name__ == "__main__":

    with open("./1.input.txt") as f:

        for l in f:
            line = l.strip()

            floor = line.count('(') - line.count(')')
            print("Floor {}".format(floor))

            floor = 0
            for idx, c in enumerate(line):
                floor += 1 if c == '(' else 0
                floor -= 1 if c == ')' else 0

                if floor == -1:
                    print("In basement, at position {}".format(idx + 1))
                    break
