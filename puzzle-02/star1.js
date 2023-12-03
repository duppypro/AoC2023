/*******************************************************************************
 *  (c) 2023, David 'Duppy' Proctor
 *  
 *  PUZZLE-02 STAR 1
 *  https://adventofcode.com/2020/day/2
 *******************************************************************************/
/*******************************************************************************
--- Day 2: Cube Conundrum ---
You're launched high into the atmosphere! The apex of your trajectory just barely reaches the surface of a large island floating in the sky. You gently land in a fluffy pile of leaves. It's quite cold, but you don't see much snow. An Elf runs over to greet you.

The Elf explains that you've arrived at Snow Island and apologizes for the lack of snow. He'll be happy to explain the situation, but it's a bit of a walk, so you have some time. They don't get many visitors up here; would you like to play a game in the meantime?

As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. Each time you play this game, he will hide a secret number of cubes of each color in the bag, and your goal is to figure out information about the number of cubes.

To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, grab a handful of random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.

You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).

For example, the record of a few games might look like this:

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.

The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?

In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that configuration. However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at once; similarly, game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. If you add up the IDs of the games that would have been possible, you get 8.

Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?
 *******************************************************************************/

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
        // check if the bag is possible
        possible = true
        for (color in bag_guess) {
            if (bag_guess[color] > q[color]) {
                possible = false
            }
        }

        if (possible) { answer += +id }
        log('Game', +id, ':', possible ? 'is possible' : 'is NOT possible')
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