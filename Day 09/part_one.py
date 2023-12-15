####################################################################################################
# Advent of Code 2023
# Day 09 Part One
####################################################################################################

import sys


def parse_stdin():
    for line in sys.stdin:
        parse_line(line)
    print(f'\nEOF')
    return
# end parse_stdin()

def parse_line(line):
    global total
    numbers = [int(n) for n in line.split()]
    total += next_value(numbers)
    print(line, end='')
    return
# end parse()

def next_value(numbers):
    # calc the difference of last 2 numbers
    diff = numbers[-1] - numbers[-2]
    return numbers[-1] + diff
# end next_value()


if __name__ == '__main__':
    total = 0
    parse_stdin()
    print(f'\n    sample.txt expects 18 + 28 + 68 = 114')
    print(f'    total = {total}')
