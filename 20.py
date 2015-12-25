def presents_for_house(house):
    num_presents = 0

    for i in range(1, house + 1):
        if house % i == 0:
            num_presents += 10 * i

    return num_presents


if __name__ == "__main__":

    with open("./20.input.txt") as f:
        target = int(f.read().strip())

        num_presents = 0
        house = 0

        while num_presents < target:
            house += 1
            num_presents = presents_for_house(house)

        print("House {} got {} presents.".format(house, num_presents))
