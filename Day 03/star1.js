/*******************************************************************************
 *  (c) 2023, David 'Duppy' Proctor
 *  
 *  PUZZLE-03 STAR 1 ⭐
 *  https://adventofcode.com/2020/day/3
 *******************************************************************************/
/*******************************************************************************
--- Day 3: Gear Ratios ---
You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.

It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

"Aaah!"

You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.

The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

Here is an example engine schematic:

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
In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
********************************************************************************/

const read_lines = require('readline')
function log(...t) { console.log(...t) }
let answer = 0 // so far all puzzles ask for a sum of something
let schematic = []
let possible_pns = new Set()

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
    // log(schematic[y - 1].slice(x - 1, x + len + 1))
    // log(schematic[y].slice(x - 1, x + len + 1))
    // log(schematic[y + 1].slice(x - 1, x + len + 1), '\n')
    if (schematic[y - 1].slice(x - 1, x + len + 1) != '.'.repeat(len + 2)) return true
    if (schematic[y + 1].slice(x - 1, x + len + 1) != '.'.repeat(len + 2)) return true
    // check the column to the left and right
    if (schematic[y][x - 1] != '.') return true
    if (schematic[y][x + len] != '.') return true
    return false
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
    answer = 0
    log('')
    for (let pn of possible_pns) {
        if (is_valid(pn)) {
            answer += pn.pn
            log(`VALID ${pn.pn} at ${pn.y},${pn.x} for ${pn.len} chars. a=${answer}`)
        } else {
            log(` NOT  ${pn.pn} at ${pn.y},${pn.x} for ${pn.len} chars`)
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
        console.log(`${answer} copied to clipboard!`)
    })
}
solve()