import re


def next_code(code):
    return (code * 252533) % 33554393


def value_at_point(col, row):
    return sum(range(col + row - 1)) + col


if __name__ == "__main__":

    with open('./day25.input.txt') as f:
        m = re.findall(r'\d+', f.read())

        first_code = 20151125
        row, col = tuple([int(n) for n in m])

        # row, col = (2, 2)

        print("Row {}, column {}".format(row, col))
        assert next_code(first_code) == 31916031

        code_num = value_at_point(col, row)

        code = first_code
        for i in range(1, code_num):
            code = next_code(code)

        print("Code at row {}, column {} is: {}".format(row, col, code))

        # code = first_code
        # for i in range(0, 22):
        #     print(i + 1, code)
        #     code = next_code(code)

