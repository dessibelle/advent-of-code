import hashlib


def calculate_md5(val):
    m = hashlib.md5()
    m.update(val)
    return m.hexdigest()


def find_hex(lead, initial=0, length=5):
    counter = initial - 1
    result = ""

    while counter < initial or result[:length] != '0' * length:
        counter += 1
        result = calculate_md5(bytes(lead.encode("utf8")) + bytes(str(counter).encode("utf8")))

    return counter, result


if __name__ == "__main__":

    with open("./day4.input.txt") as f:

        target_hash = f.read().strip()

        first5, r = find_hex(target_hash)
        first6, r = find_hex(target_hash, first5, 6)

        print(first5)
        print(first6)
