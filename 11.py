import re
import time


def to_base(num, numerals="abcdefghijklmnopqrstuvwxyz"):
    b = len(numerals)
    return ((num == 0) and numerals[0]) or (to_base(num // b, numerals).lstrip(numerals[0]) + numerals[num % b])


def from_base(num, numerals="abcdefghijklmnopqrstuvwxyz"):
    b = len(numerals)

    if len(num) == 0:
        return 0

    exponent = len(num) - 1
    return numerals.index(num[0]) * b ** exponent + from_base(num[1:], numerals)


def increment_password(password):
    pw = from_base(password)
    return to_base(pw + 1)


illegal_chars = re.compile(r'[iol]')
pairs = re.compile(r"([a-z])\1.*([a-z])\2")


def verify_password(password):
    def has_increment(password):
        for i in range(0, len(password) - 3):
            if ord(password[i]) == ord(password[i + 1]) - 1 == ord(password[i + 2]) - 2:
                return True
        return False

    return (
        pairs.search(password) is not None and
        illegal_chars.search(password) is None and
        has_increment(password)
    )


if __name__ == "__main__":

    assert verify_password("hijklmmn") is False
    assert verify_password("abbceffg") is False
    assert verify_password("abbcegjk") is False
    assert verify_password("abcdffaa") is True
    assert verify_password("ghjaabcc") is True

    password = "vzbxkghb"
    # password = "vzbxxyzz"

    start_time = time.time()

    valid = False
    num = 0
    while not valid:
        num += 1
        password = increment_password(password)
        valid = verify_password(password)

    print("Valid password ({} iterations): {}".format(num, password))

    print("--- %s seconds ---" % (time.time() - start_time))
