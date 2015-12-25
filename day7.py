class FileParser(object):

    def __init__(self, path):
        self.path = path

        self.instructions = []
        self.register = {}
        self.operations = {
            "AND": self.and_,
            "OR": self.or_,
            "NOT": self.not_,
            "LSHIFT": self.lshift,
            "RSHIFT": self.rshift,
            "->": self.store,
        }

        self.parse()

    def parse(self):
        with open(self.path) as f:
            for line in f:
                self.instructions.append(line.strip())

    def execute(self):
        while len(self.instructions):
            for idx, inst in enumerate(self.instructions):
                try:
                    self.execute_instruction(inst)
                except:
                    pass
                else:
                    self.instructions.pop(idx)
                    break

    def execute_instruction(self, line):
        line = line.strip()
        args = line.split(" ")

        varname = args.pop()
        store_op = args.pop()
        r = self.lookup_varname(args.pop())
        op = args.pop() if len(args) else None
        l = self.lookup_varname(args.pop() if len(args) else '0')

        self.perform_operation(
            store_op,
            varname,
            self.perform_operation(op, l, r) if op else r
        )

    def lookup_varname(self, varname):
        return int(varname) if varname.isdigit() else self.register[varname]

    def perform_operation(self, opcode, l, r):
        print(opcode, l, r)
        op = self.operations[opcode]
        return op(l, r)

    def and_(self, l, r):
        return l & r

    def or_(self, l, r):
        return l | r

    def not_(self, l, r):
        return 2 ** 16 + ~r

    def lshift(self, l, r):
        return l << r

    def rshift(self, l, r):
        return l >> r

    def store(self, key, val):
        self.register[key] = val


if __name__ == "__main__":

    parser = FileParser("./7.input.txt")
    parser.execute()

    print(parser.register)
    print(parser.register.get('a'))
