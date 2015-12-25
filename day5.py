import re


allowed = re.compile(r'^((?!ab|cd|pq|xy).)*$')
vovels = re.compile(r'[aeiou].*[aeiou].*[aeiou]')
repeats = re.compile(r'([a-z])\1{1,}')


pairs = re.compile(r'([a-z]{2}).*\1{1,}')
between = re.compile(r'([a-z])[a-z]\1')


def nice_v1(word):
    return allowed.search(word) and vovels.search(word) and repeats.search(word)


def nice_v2(word):
    return pairs.search(word) and between.search(word)


def evaluate_words(words, evaluator):
    evaluations = []
    for word in words:
        evaluations.append(evaluator(word))
    return evaluations

if __name__ == "__main__":

    with open("./5.input.txt") as f:

        words = []

        for line in f:
            words.append(line.strip())

        nice_words_v1 = list(filter(None, evaluate_words(words, nice_v1)))
        print(len(nice_words_v1))

        nice_words_v2 = list(filter(None, evaluate_words(words, nice_v2)))
        print(len(nice_words_v2))
