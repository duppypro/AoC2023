##########################################
############ PASSED sample.txt ###########
############# FAIL input.txt #############
##########################################

# --- Part Two ---
# Everyone will starve if you only plant such a small number of seeds. Re-reading the almanac, it looks like the seeds: line actually describes ranges of seed numbers.

# The values on the initial seeds: line come in pairs. Within each pair, the first value is the start of the range and the second value is the length of the range. So, in the first line of the example above:

# seeds: 79 14 55 13
# This line describes two ranges of seed numbers to be planted in the garden. The first range starts with seed number 79 and contains 14 values: 79, 80, ..., 91, 92. The second range starts with seed number 55 and contains 13 values: 55, 56, ..., 66, 67.

# Now, rather than considering four seed numbers, you need to consider a total of 27 seed numbers.

# In the above example, the lowest location number can be obtained from seed number 82, which corresponds to soil 84, fertilizer 84, water 84, light 77, temperature 45, humidity 46, and location 46. So, the lowest location number is 46.

# Consider all of the initial seed numbers listed in the ranges on the first line of the almanac. What is the lowest location number that corresponds to any of the initial seed numbers?

function min_of(a,b) { return a < b ? a : b }
function max(a,b) { return a > b ? a : b }
function push(_array, _val) { _array[length(_array) + 1] = _val}

function closest(starts_stack, lasts_stack, min, i) {
    min = 1.0e18 # something bigger than any of the ids
    for (k in starts_stack) {
        if (lasts_stack[k] != 0) {
            min = min_of(starts_stack[k], min)
        }
    }
    return min
}

function push_ranges_from_all_ranges_one_map(_out_starts_stack, _out_lasts_stack,_in_starts_stack, _in_lasts_stack,_map_out_start, _map_in_start, _map_in_last)
{
    for (key in _in_starts_stack) {
        push_ranges_from_one_range_one_map(_out_starts_stack, _out_lasts_stack, _in_starts_stack[key], _in_lasts_stack[key], _map_out_start, _map_in_start, _map_in_last)
        if (mapped) { # don't run this full range through future maps
            # don't use delete because we need to keep the key so 
            # that the _in_foo[] acts like a stack not array and push() works
            # printf "   |   |   |mapped %d-%d k:%d\n", _in_starts_stack[key], _in_lasts_stack[key], key
            _in_starts_stack[key] = 0
            _in_lasts_stack[key] = 0
        }
    }
}

# start and last are inclusive
function push_ranges_from_one_range_one_map(_out_starts_stack, _out_lasts_stack, _in_start, _in_last, _map_out_start, _map_in_start, _map_in_last)
{
    # maximum 3 possible output ranges,
    # only 1 of them is mapped
    # push them on to the _out_ranges array
    mapped = false
    if (!_in_last) {
        return # skip empty (already mapped) ranges
    }
    printf "   |   |%d-%d maps to:\n", _in_start, _in_last
    if (_in_start < _map_in_start) {
        # push the range before the mapped range
        if (_in_last < _map_in_start) {
            push(_out_starts_stack, _in_start)
            push(_out_lasts_stack, _in_last)
            printf "   |   |   |left:%d-%d\n", _in_start, _in_last
            return mapped
        }
        push(_out_starts_stack, _in_start)
        push(_out_lasts_stack, _map_in_start - 1)
        printf "   |   |   |left:%d-%d\n", _in_start, _map_in_start - 1
        # start a new range, this part will be mapped
        _in_start = _map_in_start
    }
    if (_in_start <= _map_in_last) {
        if (_in_last <= _map_in_last) {
            push(next_starts_stack, _map_out_start - _map_in_start + _in_start)
            push(next_lasts_stack,  _map_out_start - _map_in_start + _in_last )
            mapped = true
            printf "   |   |---|MAP:%d-%d\n", _map_out_start - _map_in_start + _in_start, _map_out_start - _map_in_start + _in_last
            return mapped
        }
        push(next_starts_stack, _map_out_start - _map_in_start + _in_start)
        push(next_lasts_stack, _map_in_last)
        mapped = true
        printf "   |   |---|MAP:%d-%d\n", _map_out_start - _map_in_start + _in_start, _map_in_last
        _in_start = _map_in_last + 1
    }
    push(_out_starts_stack, _in_start)
    push(_out_lasts_stack, _in_last)
    printf "   |   |   |right:%d-%d\n", _in_start, _in_last
    return mapped
}

BEGIN {
}

{sub(/\r$/, "", $NF)} # fix Windows line endings for every line
# if we don't do this then the line "name map:\r\n" on Windows
# $NF will be "map:\r" and not match /map:$/
# and we cant fix by using /map:\r$/ because the \r isn't there on unix and Mac
# could fix by always doing /map:[\r]{0,1}$/ but we won't remember always
# and we might be matching on something that doesn't have to be last
# and its hard for new readers to pick up

/^seeds:/ {
    print $0
    split($0, seed_ranges, " "); delete seed_ranges[1]
    delete out_starts_stack; delete out_lasts_stack
    range_num = 2
    while (range_num <= length(seed_ranges)) {
        start = seed_ranges[range_num]
        last = start + seed_ranges[range_num + 1] - 1
        push(out_starts_stack, start); push(out_lasts_stack, last)
        range_num += 2
    }
}

/map:$/ { # starts a new map consisting of multiple ranges
    printf "ranges:"
    # the previous mapped output is now input
    # awk can't re-point arrays as in: in_starts = out_starts; in_lasts = out_lasts
    for (k in out_starts_stack) {
        printf " %d-%d", out_starts_stack[k], out_lasts_stack[k]
    }
    print "\n" $0
    for (k in next_starts_stack) {
        push(out_starts_stack, next_starts_stack[k])
        push(out_lasts_stack, next_lasts_stack[k])
    }
    delete next_starts_stack; delete next_lasts_stack

}

/^[0-9]+ [0-9]+ [0-9]+$/ { # one range per line in a map
    # $1 dest start
    # $2 source start
    # $3 is range length
    map_dest_start = $1
    map_src_start = $2
    map_src_count = $3
    map_src_last = map_src_start + map_src_count - 1
    map_dest_last = map_dest_start + map_src_count - 1

    printf "    %d-%d -> %d-%d\n", map_src_start, map_src_last, map_dest_start, map_dest_last

    delete in_starts_stack; delete in_lasts_stack
    for (k in out_starts_stack) {
        in_starts_stack[k] = out_starts_stack[k]
        in_lasts_stack[k]  = out_lasts_stack[k]
    }
    delete out_starts_stack; delete out_lasts_stack

    push_ranges_from_all_ranges_one_map(out_starts_stack, out_lasts_stack, in_starts_stack, in_lasts_stack, map_dest_start, map_src_start, map_src_last)
}

END {
    printf "\nout_starts before fix:"
    for (key in out_starts_stack) { printf " %d", out_starts_stack[key] }

    for (k in next_starts_stack) {
        push(out_starts_stack, next_starts_stack[k])
        push(out_lasts_stack, next_lasts_stack[k])
    }
    delete next_starts_stack; delete next_lasts_stack

    printf "\nout_starts with next_starts:"
    for (key in out_starts_stack) { printf " %d", out_starts_stack[key] }

    printf "\n\n    Sample has closest location of 46.\n"
    print "Closest location is " closest(out_starts_stack, out_lasts_stack) "."
}