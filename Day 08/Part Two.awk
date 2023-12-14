# --- Day 8: Haunted Wasteland ---
# Part Two

#########################################################################
# functions here

#########################################################################
# BEGIN
BEGIN {
    true = 1; false = 0
    total_steps = 0
    delete steps # cast to array
    delete start_list
    delete dest_list
    delete chars # use as a temp array to help access individual letter of dest strings
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

/^[A-Z0-9]{3,3} = \([A-Z0-9]{3,3}, [A-Z0-9]{3,3}\)$/ { # if the line is a node
    matched = 1
    dest = $1
    split(dest, chars, "")
    if (chars[3] == "A") {
        start_list[length(start_list) + 1] = dest
    }
    if (chars[3] == "Z") {
        dest_list[length(dest_list) + 1] = dest
    } # hmmm, might not need this? just check chars[3] == "Z"?
    # $2 is the "=", skip it
    # $3 is "(ccc,"
    this_left = substr($3, 2, 3)
    # $4 is "ccc)"
    this_right = substr($4, 1, 3)
    left_fork[dest] = this_left
    right_fork[dest] = this_right
    # printf "MAP: from %s, L goes to %s and R goes to %s\n", dest, this_left, this_right
}

!/^$/ {
    if (!matched) {
        printf "\n*****\nERROR: unmatched line: %s\n*****\n", $0
    }
    matched = 0
}

END {
    total_steps = 0
    # printf "#%d: start", total_steps
    # for (key in start_list) {
    #     split(start_list[key], chars, "")
    #     printf " %s", chars[3]
    # }
    # printf "\n"
    while (!all_Zs && total_steps < 1000000) {
        all_Zs = true
        dir = steps[head]
        head = (head + 1) % LEN
        # printf "#%d: %s to ", total_steps + 1, dir
        for (key in start_list) {
            you_are_here = start_list[key]
            if (dir == "L") {
                fork = left_fork[you_are_here]
            } else if (dir == "R") {
                fork = right_fork[you_are_here]
            }
            you_are_here = fork
            start_list[key] = you_are_here
            split(you_are_here, chars, "")
            # printf " %s", chars[3] == "Z" ? "Z" : "-"
            if (chars[3] != "Z") {
                all_Zs = false
            }
        }
        # printf "\n"
        total_steps++
    }
    printf "\nTotal steps to reach all xxZs: %d\n", total_steps
}
