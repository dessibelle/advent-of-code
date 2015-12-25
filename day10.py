

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

    assert look_and_see(1) == "11"
    assert look_and_see(11) == "21"
    assert look_and_see(21) == "1211"
    assert look_and_see(1211) == "111221"
    assert look_and_see(111221) == "312211"
    assert look_and_see(3) == "13"

    with open("./10.input.txt") as f:
        initial = f.read().strip()

        print("Length after {} iterations: {}".format(40, len(look_and_see(initial, 40))))
        print("Length after {} iterations: {}".format(50, len(look_and_see(initial, 50))))
