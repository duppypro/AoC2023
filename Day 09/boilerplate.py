####################################################################################################
# Python 3.10.12 boilerplate for Advent of Code 2023
####################################################################################################

import sys

def parse_line(line):
    print(line, end='')
# end parse()

def parse_stdin():
    for line in sys.stdin:
        parse_line(line)
    print()
# end main()


if __name__ == '__main__':
    parse_stdin()
