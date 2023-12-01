/*******************************************************************************
 *  (c) 2023, David 'Duppy' Proctor
 *  
 *  PUZZLE-02 STAR 1
 *  https://adventofcode.com/2020/day/2
 *******************************************************************************/
const read_lines = require('readline')

let answer = 0
let min = Infinity, max = 0

function parse(line) {
    // Prepare ahead of time with common functions of the line we might need
    let l = line.length
    let parts = line.split('')

    // init
    

    // get to work here
    return true
}

async function line_by_line(read_lines) {
    const rl = read_lines.createInterface({
        input: process.stdin,
        output: process.stdout, // Change output to stdout
        crlfDelay: Infinity
    })

    for await (const line of rl) {
        if (!line || line.length == 0 || !parse(line)) {
            break
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
line_by_line()