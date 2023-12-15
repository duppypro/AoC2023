# split line into 2 parts before and after '|' and save number fields in arrays left_card and right_card
/^Card/ { # only processlines that contain 'Card'
    printf "%s %s You matched ", $1, $2
    delete winners
    matches = 0
    field = 3 # skip over field $1 'Card' and field $2 ID
    while($field != "|" && field <= NF) {
        winners[+$field] = "Match!"
        field++
    }
    field++ # skip '|'
    while(field <= NF+1) {
        if(+$field in winners) {
            printf "%d, ", $field
            matches++
        }
        field++
    }
    if (matches > 0) {
        score = 2 ** (matches-1)
        answer += score
    } else {
        score = 0
    }

    printf "score = %d, answer=%d\n", score, answer
}
END {
    print "answer=" answer
}
