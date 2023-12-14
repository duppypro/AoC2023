# --- Day 8: Haunted Wasteland ---
# Part one

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
    while (you_are_here != dest && total_steps < 1000000) {
        dir = steps[head]
        head = (head + 1) % LEN
        if (dir == "L") {
            fork = left_fork[you_are_here]
        } else if (dir == "R") {
            fork = right_fork[you_are_here]
        } else {
            printf "\n*****\nERROR: invalid direction: %s\n*****\n", dir
        }
        total_steps++
        printf "Step %d from %s go %s to %s\n", total_steps, you_are_here, dir, fork
        you_are_here = fork
    }
    printf "\nTotal steps to reach ZZZ: %d\n", total_steps
}
