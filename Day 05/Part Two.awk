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

function min(a,b) { return a < b ? a : b }
function max(a,b) { return a > b ? a : b }
function push(_array, _val) { _array[length(_array) + 1] = _val}

function closest(array, min, i) {
    min = 1.0e100 # something bigger than any of the ids
    for (i in array) { if (array[i] < min) { min = array[i] }}
    return min
}

function push_ranges_from_all_ranges_all_maps(_out_starts, _out_lasts, _in_starts, _in_lasts, _map_out_starts, _map_in_starts, _map_in_lasts) {
    # for each range in _in_ranges
    #   for each map in _map_ranges
    #       push_ranges_from_one_range_one_map(_out_starts, _out_lasts, _in_start, _in_last, _map_out_start, _map_in_start, _map_in_last)
    #   end for
    # end for
    for (i_range in _in_starts) {
        for (i_map in _map_in_starts) {
            push_ranges_from_one_range_one_map(_out_starts, _out_lasts, _in_starts[i_range], _in_lasts[i_range], _map_out_starts[i_map], _map_in_starts[i_map], _map_in_lasts[i_map])
        }
    }
}

# start and last are inclusive
function push_ranges_from_one_range_one_map(_out_starts, _out_lasts, _in_start, _in_last, _map_out_start, _map_in_start, _map_in_last) {
    # maximum 3 possible output ranges,
    # only 1 of them is mapped
    # push them on to the _out_ranges array
    if (_in_start < _map_in_start) {
        # push the range before the mapped range
        push(_out_starts, _in_start)
        if (_in_last < _map_in_start) {
            push(_out_lasts, _in_last)
            return
        }
        push(_out_lasts, _map_in_start - 1)
        # start a new range, this part will be mapped
        _in_start = _map_in_start
    }

    if (_in_start <= _map_in_last) {
        push(   _out_starts, _map_out_start - _map_in_start + _in_start)
        if (_in_last <= _map_in_last) {
            push(_out_lasts, _map_out_start - _map_in_start + _in_last)
            return
        }
        push(_out_lasts, _map_in_last)
        _in_start = _map_in_last + 1
    }
    push(_out_starts, _in_start)
    push(_out_lasts, _in_last)
}

BEGIN {
    true = 1; false = 0
    delete location_yet # this makes it an array
    # so that length(location_yet) won't complain about a scalar the first time through
    delete map_names # likewise
    delete out_starts
    delete out_lasts
}

{sub(/\r$/, "", $NF)} # fix Windows line endings

/^seeds:/ {
    print $1
    split($0, seed_ranges, " "); delete seed_ranges[1]
    range_num = 2
    while (range_num <= length(seed_ranges)) {
        seed_id = seed_ranges[range_num]
            print "Expand range: from " seed_ranges[range_num] " for " seed_ranges[range_num + 1]
        while (seed_id < seed_ranges[range_num] + seed_ranges[range_num + 1]) {
            # push seed_id onto location_yet
            location_yet[length(location_yet) + 1] = seed_id
            # BUG: #1 pushing the range expansion was a good idea for sample
            # FAIL but for input.txt the first range size is 187,012,821 !!!!
            seed_id++
        }
        printf "\n"
        range_num += 2
    }
}

/map:$/ {
    for (seed_num in location_yet) { printf " %d from %d", location_yet[seed_num], seed_num }
    printf "\n\n"
    print "apply map: " $1
    delete map_applied
}

/^[0-9]+ [0-9]+ [0-9]+$/ {
    # $1 dest start
    # $2 source start
    # $3 is range length
    for (seed_num in location_yet) {
        if (!map_applied[seed_num]) {
            if (location_yet[seed_num] >= $2 && location_yet[seed_num] < $2 + $3) {
                location_yet[seed_num] = $1 + location_yet[seed_num] - $2
                map_applied[seed_num] = true
            }
        }
    }
}

END {
    printf "\n out_starts:"
    for (i in out_starts) { printf " %d", out_starts[i] }
    printf "\n\n    Sample has closest location of 46.\n"
    print "Closest location is " closest(out_starts) "."
}