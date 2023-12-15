####################################################################################################
# Advent of Code 2023
# Day 09 Part One
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
    next_num = next_value(numbers)[-1]
    global total
    total += next_num
    print(f'{line} -> {next_num}\n', end='')
    return
# end parse()

def next_value(in_numbers: list) -> list:
    numbers = in_numbers.copy()
    if numbers[-1] == 0:
        return numbers  
    diffs = []
    sum_of_diffs = 0
    for i in range(len(numbers) - 1):
        diffs.append(numbers[i + 1] - numbers[i])
        sum_of_diffs += diffs[-1]
    # print(f'    diffs = {diffs}')
    next_num = next_value(diffs).copy()
    numbers.append(numbers[-1] + next_num[-1])
    return numbers.copy()
# end next_value()


if __name__ == '__main__':
    total = 0
    parse_stdin()
    print(f'\n    sample.txt expects 18 + 28 + 68 = 114')
    print(f'    total = {total}')
    # add total to the system clipboard
    pyperclip.copy(total)
    print(f'    {total} copied to clipboard')
    
