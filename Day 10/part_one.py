####################################################################################################
# Copyright 2023, David 'Duppy' Proctor
#
# $ source ./env/bin/activate
#
# Day 10: Part One
# https://adventofcode.com/2023/day/10
#
####################################################################################################

import sys
import pyperclip
import argparse

def begin(answer=0):
    answer = 0
    print('BEGIN')
    return answer

def parse_file(input, answer):
    with open(input, 'r') as sys.stdin:
        for line in sys.stdin:
            answer = parse_line(line, answer)
    print(f'EOF: file closed')
    return answer

def end(answer):
    print('END')
    return answer

def parse_line(line, answer):
    answer += 1
    line = line.strip()
    print(f'{line}\n', end='')
    return answer

if __name__ == '__main__':
    OG_stdout = sys.stdout
    with open('answer.txt', 'w') as sys.stdout:
        answer = begin()
        
        parser = argparse.ArgumentParser(description='get name of input file')
        parser.add_argument('-input', type=str, help='the input file for stdin')
        args = parser.parse_args()
        
        answer = parse_file(args.input or 'input.txt', answer)
        
        answer = end(answer)
        print('    sample_1.txt expects answer = 4')
        print('    sample_2.txt expects answer = 8')
        print(f'        answer = {answer}')
        pyperclip.copy(answer)
        print(f'        {answer} copied to clipboard')
    
    sys.stdout = OG_stdout
    print(f'File closed, answer = {answer}')
