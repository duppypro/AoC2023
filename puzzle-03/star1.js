/*******************************************************************************
 *  (c) 2023, David 'Duppy' Proctor
 *  
 *  PUZZLE-03 STAR 1 ⭐
 *  https://adventofcode.com/2020/day/3
 *******************************************************************************/
/*******************************************************************************

********************************************************************************/

const read_lines = require('readline')
function log(...t) { console.log(...t) }
let answer = 0 // so far all puzzles ask for a sum of something
let check_answer = false
let id = 0

function begin() {
    // set up the problem if needed
    log('begin')
    check_answer = 42
}

function parse(line) {
    log(line)
    // get to work here

    answer += 1
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