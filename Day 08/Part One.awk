# --- Day 8: Haunted Wasteland ---
# You're still riding a camel across Desert Island when you spot a sandstorm quickly approaching. When you turn to warn the Elf, she disappears before your eyes! To be fair, she had just finished warning you about ghosts a few minutes ago.

# One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of left/right instructions, and the rest of the documents seem to describe some kind of network of labeled nodes.

# It seems like you're meant to use the left/right instructions to navigate the network. Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!

# After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel like AAA is where you are now, and you have to follow the left/right instructions until you reach ZZZ.

# This format defines each node of the network individually. For example:

# RL

# AAA = (BBB, CCC)
# BBB = (DDD, EEE)
# CCC = (ZZZ, GGG)
# DDD = (DDD, DDD)
# EEE = (EEE, EEE)
# GGG = (GGG, GGG)
# ZZZ = (ZZZ, ZZZ)
# Starting with AAA, you need to look up the next element based on the next left/right instruction in your input. In this example, start with AAA and go right (R) by choosing the right element of AAA, CCC. Then, L means to choose the left element of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.

# Of course, you might not find ZZZ right away. If you run out of left/right instructions, repeat the whole sequence of instructions as necessary: RL really means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that takes 6 steps to reach ZZZ:

# LLR

# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)
# Starting at AAA, follow the left/right instructions. How many steps are required to reach ZZZ?

#########################################################################
# functions here

#########################################################################
# BEGIN
BEGIN {
    true = 1; false = 0
    total_steps = 0
    delete steps # cast to array
}

{sub(/\r$/, "", $NF)} # fix Windows line endings for every line

/^[LR]+$/ { # if the line contains only L and R
    matched = 1
    if (length(steps)) {
        printf "\n*****\nERROR: multiple lines with L and R\n*****\n"
    }
    split($0, steps, "") # split the line into an array of characters
    # mmove last step to step[0] so we can mod the index
    # also start head at 1
    steps[0] = steps[length(steps)]
    head = 1
    LEN = length(steps) - 1
    for (i = 0; i < LEN; i++) {
        printf "%s", steps[i]
    }
    printf "\n"
}

/^[A-Z]{3,3} = \([A-Z]{3,3}, [A-Z]{3,3}\)$/ { # if the line is a node
    matched = 1
    road = $1
    if (road == "AAA") {
        if (found_start) {
            printf "\n*****\nERROR: multiple start nodes\n*****\n"
        }
        found_start = true
    }
    if (road == "ZZZ") {
        if (found_end) {
            printf "\n*****\nERROR: multiple end nodes\n*****\n"
        }
        found_end = true
    }
    this_left = substr($3, 2, 3)
    this_right = substr($4, 1, 3)
    left_fork[road] = this_left
    right_fork[road] = this_right
    printf "node %s has left fork %s and right fork %s\n", road, left_fork[road], right_fork[road]
}

!/^$/ {
    if (!matched) {
        printf "\n*****\nERROR: unmatched line: %s\n*****\n", $0
    }
    matched = 0
}

END {
    start = "AAA"
    dest = "ZZZ"
    if (!found_start) {
        printf "\n*****\nERROR: no start node\n*****\n"
    }
    if (!found_end) {
        printf "\n*****\nERROR: no end node\n*****\n"
    }
    you_are_here = start
    total_steps = 0
    while (you_are_here != dest && total_steps < 12) {
        dir = steps[head]
        head = (head + 1) % LEN
        if (dir == "L") {
            fork = left_fork[you_are_here]
        } else if (dir == "R") {
            fork = right_fork[you_are_here]
        } else {
            printf "\n*****\nERROR: invalid direction: %s\n*****\n", dir
        }
        printf "from %s go %s to %s\n", you_are_here, dir, fork
        you_are_here = fork
        total_steps++
    }
    printf "\nTotal steps to reach ZZZ: %d\n", total_steps
}
