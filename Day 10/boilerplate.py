####################################################################################################
# Copyright 2023, David 'Duppy' Proctor
#
# Python 3.10.12 boilerplate for Advent of Code 2023
# $ source ./env/bin/activate
####################################################################################################

import sys
import pyperclip

answer = 0

def begin():
    global answer
    answer = 0
    print('BEGIN')
    return answer

def parse_stdin():
    global answer
    for line in sys.stdin:
        parse_line(line)
    print(f'EOF')

def end(answer=0):
    print('END')
    return answer

def parse_line(line):
    global answer
    line = line.strip()
    print(f'{line}\n', end='')
    return

if __name__ == '__main__':
    answer = begin()
    parse_stdin()
    answer = end(answer)
    print('    sample1.txt expects answer = 4')
    print('    sample2.txt expects answer = 8')
    print(f'        answer = {answer}')
    # add answer to the system clipboard
    pyperclip.copy(answer)
    print(f'        {answer} copied to clipboard')
