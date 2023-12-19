####################################################################################################
# Copyright 2023, David 'Duppy' Proctor
#
# $ source ./env/bin/activate
#
# Day 10: Part Two
# https://adventofcode.com/2023/day/10#part2
#
####################################################################################################

import sys
import pyperclip
import argparse

pipe_2d = []
dist_2d = []
critter_location = [-1, -1]

# Define some ANSI escape codes for colors
RED = '\033[31m'
GREEN = '\033[32m'
BLUE = '\033[34m'
RESET = '\033[0m'

# Print some colored text
print(f'{RED}This text is red.{RESET}')
print(f'{GREEN}This text is green.{RESET}')
print(f'{BLUE}This text is blue.{RESET}')

def main():
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
# end main()


def begin(answer=0):
    answer = 0
    print('BEGIN')
    return answer

def parse_file(input, answer):
    with open(input, 'r') as sys.stdin:
        for line in sys.stdin:
            row = []
            answer = parse_line(line, row, answer)
            pipe_2d.append(row)
            dist_2d.append([-1] * len(row))
    print(f'EOF: file closed')
    return answer

def end(answer):
    print('\nEND')
    left_fill = critter_location.copy() # don't really need to copy in this case
    right_fill = critter_location.copy()
    num_steps = -1
    while peek_2d(dist_2d, left_fill) == -1:
        num_steps += 1
        poke_2d(dist_2d, left_fill, num_steps)
        poke_2d(dist_2d, right_fill, num_steps)
        # brute force (unroll) search for connected pipes
        cw         = [[0, -1], [-1, 0], [0, 1], [1, 0]]
        connect_cw = [  '┌└─',   '┌┐│',  '┐┘─',  '┘└│']
        old_right_fill = right_fill.copy()
        for i, look_dir in enumerate(cw):
            look_at = move_2d(right_fill, look_dir)
            if peek_2d(pipe_2d, look_at) in connect_cw[i]:
                if peek_2d(pipe_2d, right_fill) in (connect_cw[(i+2) % 4] + 'X'):
                    right_fill = look_at.copy()
                    break
        ccw         = [[1, 0], [0, 1], [-1, 0], [0, -1]]
        connect_ccw = [ '┘└│',  '┐┘─',   '┌┐│',   '┌└─']
        old_left_fill = left_fill.copy()
        for i, look_dir in enumerate(ccw):
            look_at = move_2d(left_fill, look_dir)
            if peek_2d(pipe_2d, look_at) in connect_ccw[i]:
                if peek_2d(pipe_2d, left_fill) in (connect_ccw[(i+2) % 4] + 'X'):
                    left_fill = look_at.copy()
                    break
        poke_2d(pipe_2d, old_left_fill, f'{num_steps % 10}')
        poke_2d(pipe_2d, old_right_fill, f'{num_steps % 10}')
        print(f'\nnum_steps = {num_steps}')
        if num_steps % 100 == 0:
            print_2d()
        
    return num_steps
# end end()

def parse_line(line, row, answer):
    line = line.strip()
    for char in line:
        pretty = map_prettier(char)
        if pretty == 'X':
            critter_location[0] = len(pipe_2d)
            critter_location[1] = len(row)
        row.append(pretty)
    return answer

def map_prettier(char):
    c = 'F7JL-|.S'
    p = '┌┐┘└─│ X'
    to_prettier = dict(zip(c, p))
    return to_prettier[char]

def print_2d():
    loc = [0,0]
    for row in pipe_2d:
        loc[1] = 0
        for char in row:
            dist = int(peek_2d(dist_2d, loc))
            if dist > 0:
                print(f'{GREEN}{dist % 10}{RESET}', end='')
            else:
                print(f'{BLUE}{char}{RESET}', end='')
            loc[1] += 1 # col count
        print() # next line
        loc[0] += 1 # row count
    
def clip(x, _min, _max):
    return max(_min, min(_max, x))

def move_2d(start, delta):
    row = clip(start[0] + delta[0], 0, len(pipe_2d) - 1)
    col = clip(start[1] + delta[1], 0, len(pipe_2d[row]) - 1)
    return [row, col]

def peek_2d(array_2d, location):
    row = location[0]
    col = location[1]
    if row < 0 or row >= len(array_2d):
        return ' '
    if col < 0 or col >= len(array_2d[0]):
        return ' '  
    return array_2d[row][col]

def poke_2d(array_2d, location, value):
    row = location[0]
    col = location[1]
    if row < 0 or row >= len(array_2d):
        return
    if col < 0 or col >= len(array_2d[0]):
        return  
    array_2d[location[0]][location[1]] = value

if __name__ == '__main__':
    main()
