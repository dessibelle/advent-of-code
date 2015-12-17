

def look_and_see(number, num_iterations=1, iteration=0):
    if iteration < num_iterations:
        iteration += 1

        new_number = ""
        current_char = ""
        char_count = 0
        for c in str(number):
            if c != current_char and current_char:
                new_number += "{}{}".format(char_count, current_char)
                char_count = 0

            char_count += 1
            current_char = c
        new_number += "{}{}".format(char_count, current_char)

        return look_and_see(new_number, num_iterations, iteration)

    return number


if __name__ == "__main__":

    print(look_and_see(1))
    print(look_and_see(11))
    print(look_and_see(21))
    print(look_and_see(1211))
    print(look_and_see(111221))
    print(look_and_see(3))

    print(len(look_and_see(1321131112, 40)))
    print(len(look_and_see(1321131112, 50)))
