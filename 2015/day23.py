from collections import defaultdict
import re


inst_re = re.compile(r',?\s+')


class CPU(object):

    def __init__(self, registers=None):
        self.registers = registers or defaultdict(int)

    def process_instructions(self, instructions):

        counter = 0
        while counter >= 0 and counter < len(instructions):
            instruction = instructions[counter]

            value = self.process_instruction(instruction)
            counter += 1 if value is None else value

    def process_instruction(self, instruction):
        fargs = inst_re.split(instruction)
        inst = fargs[0]
        args = fargs[1:]

        if hasattr(self, inst):
            handler = getattr(self, inst)
            return handler(*args)

    def hlf(self, register):
        """r sets register r to half its current value, then continues with the next instruction."""
        self.registers[register] = int(self.registers[register] / 2)

    def tpl(self, register):
        """r sets register r to triple its current value, then continues with the next instruction."""
        self.registers[register] = int(self.registers[register] * 3)

    def inc(self, register):
        """r increments register r, adding 1 to it, then continues with the next instruction."""
        self.registers[register] = int(self.registers[register] + 1)

    def jmp(self, offset):
        """offset is a jump; it continues with the instruction offset away relative to itself."""
        return int(offset)

    def jie(self, register, offset):
        """r, offset is like jmp, but only jumps if register r is even ("jump if even")."""
        if self.registers[register] % 2 == 0:
            return int(offset)

    def jio(self, register, offset):
        """r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd)."""
        if self.registers[register] == 1:
            return int(offset)


if __name__ == "__main__":

    with open("./day23.input.txt") as f:

        instructions = []
        for line in f:
            instructions.append(line.strip())

        r = defaultdict(int)
        r["a"] = 1

        cpus = [
            CPU(),
            CPU(registers=r),
        ]

        for idx, cpu in enumerate(cpus):
            cpu.process_instructions(instructions)

            print("CPU {}:".format(idx))
            for key, value in cpu.registers.items():
                print("{}: {}".format(key, value))
            print("")
