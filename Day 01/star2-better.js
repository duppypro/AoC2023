/*******************************************************************************
--- Part Two ---
Your calculation isn't quite right. It looks like some of the digits are actually
spelled out with letters: one, two, three, four, five, six, seven, eight, and nine
also count as valid "digits".

Equipped with this new information, you now need to find the real first and last digit
on each line.

For example:
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen

In this example, the calibration values are
29, 83, 13, 24, 42, 14, and 76.
Adding these together produces 281.

What is the sum of all of the calibration values?
*******************************************************************************/
const readline = require('readline')

let answer = 0
let first_digit = 0
let last_digit = 0
let calibration_value = 0
const digits_spelled_out = 'zero, one, two, three, four, five, six, seven, eight, nine'.split(', ')
const re = new RegExp(`(?=(\\d|${digits_spelled_out.join('|')}))`, 'g')

function parse(line) {
    if (!line) {
        return null
    }
    all_digits = [...line.matchAll(re)].map(d => d[1])
    if (!all_digits) {
        return null
    }
    first_digit = digits_spelled_out.indexOf(all_digits[0])
    if (first_digit == -1) {
        first_digit = all_digits[0]
    }
    last_digit = digits_spelled_out.indexOf(all_digits.slice(-1)[0])
    if (last_digit == -1) {
        last_digit = all_digits.slice(-1)[0]
    }
    calibration_value = first_digit * 10 + last_digit * 1
    console.log(`${calibration_value} = ${first_digit} & ${last_digit} < ${line}`)
    answer += calibration_value

    return calibration_value
}

async function processLineByLine() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout, // Change output to stdout
        crlfDelay: Infinity
    })

    for await (const line of rl) {
        if (!parse(line)) {
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

processLineByLine()