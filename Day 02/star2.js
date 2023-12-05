/*******************************************************************************
 *  (c) 2023, David 'Duppy' Proctor
 *  
 *  PUZZLE-02 STAR 2 ⭐ ⭐
 *  https://adventofcode.com/2020/day/2
 *******************************************************************************/
/*******************************************************************************
--- Part Two ---
The Elf says they've stopped producing snow because they aren't getting any water! He isn't sure why the water stopped; however, he can show you how to get to the water source to check it out for yourself. It's just up ahead!

As you continue your walk, the Elf poses a second question: in each game you played, what is the fewest number of cubes of each color that could have been in the bag to make the game possible?

Again consider the example games from earlier:

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
Game 4 required at least 14 red, 3 green, and 15 blue cubes.
Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together. The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these five powers produces the sum 2286.

For each game, find the minimum set of cubes that must have been present. What is the sum of the power of these sets? *******************************************************************************/

const read_lines = require('readline')
function log(...t) { console.log(...t) }
let answer = 0 // sum of game IDs that would have been possible
let check_answer = false
let red = blue = green = 0
let bag_guess = { red, blue, green } // bag tracks the most cubes seen in a game
let q = { red, blue, green } // q is the filter we are checking against
let tag = other = []
let draw = []
let possible = false
let id = 0
// const line = ''

function begin() {
    // set up the problem
    log('begin')
}

function parse(line) {
    if (line.length > 200) { return false }

    // get to work here
    [tag, draw, ...other] = line.split(':')
    if (!tag || !draw || other.length > 0) { return true }
    draw = draw.trim()

    if (tag[0] == 'Q') {
        counts = draw.split(',').map(x => x.trim().split(' '))
        counts.map(([count, color]) => {
            q[color] = count
        })
    }

    if (tag[0] == 'A') {
        [check_answer] = draw.split(' ').map(t => t.trim())
        check_answer = parseInt(check_answer)
    }

    if (tag[0] == 'G') {
        let draws = []
        red = blue = green = 0
        bag_guess = { red, blue, green } // bag tracks the most cubes seen
        id = parseInt(tag.slice(5))
        draws = draw.split(';').map(t => t.trim())
        for (draw of draws) {
            counts = draw.split(',').map(t => t.trim().split(' '))
            counts.map(([count, color]) => {
                bag_guess[color] = Math.max(bag_guess[color], count)
            })
        }
        log('Game', +id, ':', bag_guess)
        // calculate min power of this set of cubes
        power = 1
        for (color in bag_guess) {
            power *= bag_guess[color]
        }

        answer += +power
        log('Game', +id, 'power: ', power, 'cumulative: ', answer)
    }

    return true
}

function end() {
    log('end')
    if (check_answer) {    // check the answer and log
        if (answer == check_answer) {
            log(`Answer is correct! ${answer} == ${check_answer}`)
        } else {
            log(`Answer is WRONG! ${answer} is NOT ${check_answer}`)
        }
    } else {
        log(`Answer is ${answer}`)
    }
}

// boilerplate code
async function line_by_line(read_lines) {
    const rl = read_lines.createInterface({
        input: process.stdin,
        output: process.stdout, // Change output to stdout
        crlfDelay: Infinity
    })

    for await (let line of rl) {
        if (line && line.length > 0) {
            parse(line)
        }
    }

    console.log(`${answer} is the answer!`)
    console.error(answer)
    // add answer to clipboard
    const { exec } = require('child_process')
    exec(`echo ${answer} | clip.exe`, (error, stdout, stderr) => {
        if (error) {
            console.error(`clip.exe error: ${error}`)
            return
        }
        console.log(`${answer} added to clipboard!`)
    })

}

const solve = async () => {
    begin()
    await line_by_line(read_lines)
    end()
}

solve()