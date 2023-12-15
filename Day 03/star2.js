/*******************************************************************************
 *  (c) 2023, David 'Duppy' Proctor
 *  
 *  PUZZLE-03 STAR 2 ⭐ ⭐
 *  https://adventofcode.com/2020/day/3
 *******************************************************************************/
/*******************************************************************************
--- Part Two ---
The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.

You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.

Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.

The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.

This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.

Consider the same engine schematic again:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.

What is the sum of all of the gear ratios in your engine schematic?
********************************************************************************/

const read_lines = require('readline')
function log(...t) { console.log(...t) }
function err(...t) { console.error(...t) }
let answer = 0 // so far all puzzles ask for a sum of something
let schematic = []
let possible_pns = new Set()
let partnums_by_gear_y_x = {} // { y_x: [partnums] } so key.split('_') is [y, x]

function parse(line) {
    // for this puzzle load the array here and parse it later
    schematic.push(line)
    return true
}

function parse_schematic() {
    // pad the schematic with empty lines to make it easier to parse
    schematic.unshift('.'.repeat(schematic[0].length))
    schematic.push('.'.repeat(schematic[0].length))
    schematic = schematic.map(line => `.${line}.`)
    for (let row of schematic) log(row)
    log('')

    let digits = new Set('0123456789')
    // iterate over the schematic
    // skipping the border
    let this_num = 0
    // WARN this assumes there no partnum '0' in the schematic
    let y = 0
    let partstr = ''
    let pn = 0
    for (let row of schematic) {
        let x = 0
        for (let char of row) {
            if (digits.has(char)) {
                partstr += char // appending strings, char is not number type yet
            } else {
                // here partstr is either '' or a number as string
                if (partstr) {
                    pn = parseInt(partstr, 10)
                    len = partstr.length
                    possible_pns.add(
                        { pn, x: x-len, y, len, }
                    ) // add it as a number
                    log(`${pn} at ${y},${x-len} for ${len} chars added to possible_partnums`)
                    partstr = ''
                }
            }
            x++
        }
        y++
    }
    return true
}

function is_valid(pn) {
    // scan all adjacent cells for a symbol
    // if found return true
    // else return false
    let { x, y, len } = pn
    // check the row above and below
    above = schematic[y - 1].slice(x - 1, x + len + 1)
    below = schematic[y + 1].slice(x - 1, x + len + 1)
    left = schematic[y][x - 1]
    right = schematic[y][x + len]
    empty = '.'.repeat(len + 2)
    if (above != empty) return true
    if (below != empty) return true
    // check the column to the left and right
    if (left != '.') return true
    if (right != '.') return true
    return false
}

// WARN this assumes that no number has more than 1 gear (as verified on the input sample)
function find_gear(pn) {
    // scan all adjacent cells for a symbol
    // if found return true
    // else return false
    let { x, y, len } = pn
    let gear_y_x = ''
    const above = schematic[y - 1].slice(x - 1, x + len + 1)
    const below = schematic[y + 1].slice(x - 1, x + len + 1)
    const left = schematic[y][x - 1]
    const right = schematic[y][x + len]

    if (above.includes('*')) { gear_y_x = `${y - 1}_${above.indexOf('*') + x - 1}` }
    if (below.includes('*')) { gear_y_x = `${y + 1}_${below.indexOf('*') + x - 1}` }
    if (left == '*') { gear_y_x = `${y}_${x - 1}` }
    if (right == '*') { gear_y_x = `${y}_${x + len}` }

    // WARN will only return last gear found,but I checked schematic for no more than 1 gear per partnum
    return gear_y_x
}

async function line_by_line(read_lines) {
    const rl = read_lines.createInterface({
        input: process.stdin,
        output: process.stdout, // Change output to stdout
        crlfDelay: Infinity
    })

    for await (let line of rl) {
        parse(line)
    }
}

const solve = async () => {
    await line_by_line(read_lines) // in this puzzle this just loads the array
    parse_schematic() // unique to this puzzle
    log('')
    
    // create a hash of gear y_x keys to partnums
    for (let pn of possible_pns) {
        let gear_y_x = find_gear(pn) // return the y_x of a gear touching this partnum
        if (gear_y_x) {
            // if this partnum touches a gear, add it to the hash
            partnums_by_gear_y_x[gear_y_x] = partnums_by_gear_y_x[gear_y_x] || []
            partnums_by_gear_y_x[gear_y_x].push(pn.pn)
            log(`Gear ${gear_y_x} touches partnums ${partnums_by_gear_y_x[gear_y_x].join(', ')}`)
        }
    }

    answer = 0
    // finally ready to iterate over all gears and calc their ratio (their product of partnums)
    for (let gear_y_x in partnums_by_gear_y_x) {
        let partnums = partnums_by_gear_y_x[gear_y_x]
        if (partnums.length == 2) {
            gear_ratio = partnums[0] * partnums[1]
            answer += gear_ratio
            log(`Gear ${gear_y_x} ratio ${gear_ratio}, sum of ratios:${answer}`)
        } else {
            log(`SKIP gear ${gear_y_x} with ${partnums.length} partnums`)
            err(`SKIP gear ${gear_y_x} with ${partnums.length} partnums`)
        }
    }

    log(`${answer} is the answer!`)
    err(answer)
    // add answer to clipboard
    const { exec } = require('child_process')
    exec(`echo ${answer} | clip.exe`, (error, stdout, stderr) => {
        if (error) {
            err(`clip.exe error: ${error}`)
            return
        }
        log(`${answer} copied to clipboard!`)
    })
}
solve()