####################################################################################################
# Advent of Code 2023
# Day 09 Part Two
####################################################################################################

import sys
import pyperclip


def parse_stdin():
    for line in sys.stdin:
        parse_line(line)
    print(f'EOF')
    return
# end parse_stdin()

def parse_line(line):
    line = line.strip()
    numbers = [int(n) for n in line.split(' ')]
    next = next_value(numbers)
    next_num = next[0]
    global total
    total += next_num
    print(f'{next_num} <- {line}\n', end='')
    return
# end parse()

def next_value(numbers: list) -> list:
    if numbers == [0] * len(numbers):
        return numbers  
    diffs = []
    for i in range(len(numbers) - 1):
        diffs.append(numbers[i + 1] - numbers[i])
    next = next_value(diffs)
    return [numbers[0] - next[0]] + numbers
# end next_value()


if __name__ == '__main__':
    total = 0
    parse_stdin()
    print(f'\n    sample.txt expects -3 + 0 + 5 = 2')
    print(f'        total = {total}')
    # add total to the system clipboard
    pyperclip.copy(total)
    print(f'        {total} copied to clipboard')
    
