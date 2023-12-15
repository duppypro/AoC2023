# --- Day 8: Haunted Wasteland ---
# Part Two

#########################################################################
# functions here

function gcd(x, y) {
    if (x == 0) {
        return y
    }
    if (y == 0) {
        return x
    }
    if (x == y) {
        return x
    }
    if (x > y) {
        return gcd(x - y, y)
    }
    return gcd(x, y - x)
}

function lcm(x, y) {
    if (x == 0 || y == 0) {
        return 0
    }
    return (x * y) / gcd(x, y)
}

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
    # new idea - only track to the period of each, then calculate LCM of all once found?

    # print lcm(1, 2)
    # print lcm(7000, 3000)
    # print lcm(14999, 200093)
    total_steps = 0
    cycles_not_found = length(start_list)
    printf "#%d: %d starts", total_steps, length(start_list)
    for (key in start_list) {
        split(start_list[key], chars, "")
        printf " %s", chars[3]
    }
    printf "\n"
    delete first_Z_list
    while (cycles_not_found && total_steps < 100000000000) {
        total_steps++
        all_Zs = true
        dir = steps[head]
        head = (head + 1) % LEN
        for (key in start_list) {
            you_are_here = start_list[key]
            if (dir == "L") {
                you_are_here = left_fork[you_are_here]
            }
            if (dir == "R") {
                you_are_here = right_fork[you_are_here]
            }
            start_list[key] = you_are_here
            if (substr(you_are_here, 3, 1) == "Z") {
                if (!first_Z_list[cycles_not_found]) {
                    first_Z_list[cycles_not_found] = total_steps
                    cycles_not_found--
                    printf "#%d: steps found one! ", total_steps
                    for (k2 in start_list) {
                        printf " %s = %d,", start_list[k2], first_Z_list[k2]
                    }
                    printf "\n"
                }
            }
        }
        if (total_steps % 1000000 == 0) {
            printf "%d Million steps", total_steps / 1000000
            printf "\n"
        }
    }
    lcm_of_all = first_Z_list[1]
    i = 1
    print i, lcm_of_all
    for (i = 2; i <= length(first_Z_list); i++) {
        printf "%d LCM of %d and %d", i, lcm_of_all, first_Z_list[i]
        lcm_of_all = lcm(lcm_of_all, first_Z_list[i])
        printf " is %d\n", lcm_of_all
    }
    printf "\nTotal steps to reach all xxZs: %d\n", lcm_of_all
}
