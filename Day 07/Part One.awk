# --- Day 7: Camel Cards ---
# Your all-expenses-paid trip turns out to be a one-way, five-minute ride in an airship. (At least it's a cool airship!) It drops you off at the edge of a vast desert and descends back to Island Island.

# "Did you bring the parts?"

# You turn around to see an Elf completely covered in white clothing, wearing goggles, and riding a large camel.

# "Did you bring the parts?" she asks again, louder this time. You aren't sure what parts she's looking for; you're here to figure out why the sand stopped.

# "The parts! For the sand, yes! Come with me; I will show you." She beckons you onto the camel.

# After riding a bit across the sands of Desert Island, you can see what look like very large rocks covering half of the horizon. The Elf explains that the rocks are all along the part of Desert Island that is directly above Island Island, making it hard to even get there. Normally, they use big machines to move the rocks and filter the sand, but the machines have broken down because Desert Island recently stopped receiving the parts they need to fix the machines.

# You've already assumed it'll be your job to figure out why the parts stopped when she asks if you can help. You agree automatically.

# Because the journey will take a few days, she offers to teach you the game of Camel Cards. Camel Cards is sort of similar to poker except it's designed to be easier to play while riding a camel.

# In Camel Cards, you get a list of hands, and your goal is to order them based on the strength of each hand. A hand consists of five cards labeled one of A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2. The relative strength of each card follows this order, where A is the highest and 2 is the lowest.

# Every hand is exactly one type. From strongest to weakest, they are:

# Five of a kind, where all five cards have the same label: AAAAA
# Four of a kind, where four cards have the same label and one card has a different label: AA8AA
# Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
# Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
# Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
# One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
# High card, where all cards' labels are distinct: 23456
# Hands are primarily ordered based on type; for example, every full house is stronger than any three of a kind.

# If two hands have the same type, a second ordering rule takes effect. Start by comparing the first card in each hand. If these cards are different, the hand with the stronger first card is considered stronger. If the first card in each hand have the same label, however, then move on to considering the second card in each hand. If they differ, the hand with the higher second card wins; otherwise, continue with the third card in each hand, then the fourth, then the fifth.

# So, 33332 and 2AAAA are both four of a kind hands, but 33332 is stronger because its first card is stronger. Similarly, 77888 and 77788 are both a full house, but 77888 is stronger because its third card is stronger (and both hands have the same first and second card).

# To play Camel Cards, you are given a list of hands and their corresponding bid (your puzzle input). For example:

# 32T3K 765
# T55J5 684
# KK677 28
# KTJJT 220
# QQQJA 483
# This example shows five hands; each hand is followed by its bid amount. Each hand wins an amount equal to its bid multiplied by its rank, where the weakest hand gets rank 1, the second-weakest hand gets rank 2, and so on up to the strongest hand. Because there are five hands in this example, the strongest hand will have rank 5 and its bid will be multiplied by 5.

# So, the first step is to put the hands in order of strength:

# 32T3K is the only one pair and the other hands are all a stronger type, so it gets rank 1.
# KK677 and KTJJT are both two pair. Their first cards both have the same label, but the second card of KK677 is stronger (K vs T), so KTJJT gets rank 2 and KK677 gets rank 3.
# T55J5 and QQQJA are both three of a kind. QQQJA has a stronger first card, so it gets rank 5 and T55J5 gets rank 4.
# Now, you can determine the total winnings of this set of hands by adding up the result of multiplying each hand's bid with its rank (765 * 1 + 220 * 2 + 28 * 3 + 684 * 4 + 483 * 5). So the total winnings in this example are 6440.

# Find the rank of every hand in your set. What are the total winnings?

function value_by_hand(hand, key, i, v, values, _cards, _counts) {
    # Every hand is exactly one type. From strongest to weakest, they are:

    # Five of a kind, where all five cards have the same label: AAAAA
    # Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    # Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
    # Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
    # Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
    # One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
    # High card, where all cards' labels are distinct: 23456
    # Hands are primarily ordered based on type; for example, every full house is stronger than any three of a kind.

    # If two hands have the same type, a second ordering rule takes effect. Start by comparing the first card in each hand. If these cards are different, the hand with the stronger first card is considered stronger. If the first card in each hand have the same label, however, then move on to considering the second card in each hand. If they differ, the hand with the higher second card wins; otherwise, continue with the third card in each hand, then the fourth, then the fifth.    

    # count the number of each card in the hand
    delete _counts
    l = length(hand)
    for (key = 1; key <= l; key++) {
        value = substr(hand, key, 1)
        _counts[value]++
    }
    
    maybe_full_house = false
    maybe_two_pair = false
    lone_cards = 0
    for (key in _counts) {
        if (_counts[key] == 5) {
            return 70 # Five of a kind
        }
        if (_counts[key] == 4) {
            return 60 # Four of a kind
        }
        if (_counts[key] == 3) {
            if (maybe_two_pair) {
                return 50 # Full house
            }
            maybe_full_house = true
        }
        if (_counts[key] == 2) {
            if (maybe_full_house) {
                return 50 # Full house
            }
            if (maybe_two_pair) {
                return 30 # Two pair
            }
            maybe_two_pair = true
        }
        if (_counts[key] == 1) {
            lone_cards++
        }
    }
    if (maybe_full_house) {
        return 40 # Three of a kind
    }
    if (maybe_two_pair) {
        return 20 # One pair
    }
    if (lone_cards == 5) {
        return 10 # High card
    }
    return -1 # error
} # end value_by_hand()

BEGIN {
    true = 1; false = 0

    split("1 2 3 4 5 6 7 8 9 T J Q K A", values, " ")
    # we never use the '1' it's there to make the face values 2 match 2, 3 match 3, etc
    delete value_of_cards
    for (key in values) {
        value_of_cards[values[key]] = key
    }
    # for (key in value_of_cards) {
    #     printf "value_of_cards[%s] = %s\n", key, value_of_cards[key]
    # }

}

{sub(/\r$/, "", $NF)} # fix Windows line endings for every line
# if we don't do this then the line "name map:\r\n" on Windows
# $NF will be "map:\r" and not match /map:$/
# and we cant fix by using /map:\r$/ because the \r isn't there on unix and Mac
# could fix by always doing /map:[\r]{0,1}$/ but we won't remember always
# and we might be matching on something that doesn't have to be last
# and its hard for new readers to pick up

/^[^ ]{5,5} [0-9]+$/ {
    hands[++p] = $1
    bids[p] = $2
}

function push(stack, v) {
    stack[++stack[0]] = v
}

function insert_by_rank_sorted(hand_stack, bid_stack, v, bid, hand) {
    push(hand_stack, hand)
    push(bid_stack, bid)
}


END {
    print "HANDS BIDS"
    delete hand_by_rank
    delete bid_by_rank
    for (key in hands) {
        hand = hands[key]
        bid = bids[key]
        v = value_by_hand(hand)
        insert_by_rank_sorted(hand_by_rank, bid_by_rank, v, bid, hand)
        print hand, bid, "hand value", v
    }
    printf "\n-----\n\n"

    l = length(hand_by_rank)
    print "LENGTH(hand_by_rank) = " l
    for (i = 1; i < l; i++) {
        print "hand_by_rank[" i "] = " hand_by_rank[i] " bid = " bid_by_rank[i]
    }

    printf "\n"
    print "So the total winnings in sample.txt are 6440."
    print " (765 * 1 + 220 * 2 + 28 * 3 + 684 * 4 + 483 * 5)"
    printf "\nTotal winnings are %d.\n", total_winnings
}
