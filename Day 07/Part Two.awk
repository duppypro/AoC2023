
BEGIN {
    true = 1; false = 0
}

{sub(/\r$/, "", $NF)} # fix Windows line endings for every line
# if we don't do this then the line "name map:\r\n" on Windows
# $NF will be "map:\r" and not match /map:$/
# and we cant fix by using /map:\r$/ because the \r isn't there on unix and Mac
# could fix by always doing /map:[\r]{0,1}$/ but we won't remember always
# and we might be matching on something that doesn't have to be last
# and its hard for new readers to pick up



END {
    printf "\n"
    printf "Answer is %d.\n", wins
}
