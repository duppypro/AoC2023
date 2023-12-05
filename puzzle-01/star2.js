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
let line_num = 0
let first_digit = 0
let last_digit = 0
let calibration_value = 0
const digits_spelled_out = 'zero, one, two, three, four, five, six, seven, eight, nine'.split(', ')
const re = new RegExp(`\\d|` + digits_spelled_out.join('|'))

function parse(line) {
    if (!line) {
        return null
    }
    all_digits = line.match(re)
    if (!all_digits) {
        return true
    }

    first_digit = digits_spelled_out.indexOf(all_digits[0])
    if (first_digit < 0) {
        first_digit = all_digits && all_digits[0]
    }

    // my first answer was incorrect, it was two low
    // I think the last_digit is not working
    // I think lines like this example are the cause: 4nine7oneighthm
    // My first attempt was matching on 'one' where it should have been 'eight'
    // try searching from right most slice until match is found
    for (let i = line.length - 1; i >= 0; i--) {
        all_digits = line.slice(i).match(re)
        if (all_digits) {
            break
        }
    }
    last_digit = digits_spelled_out.indexOf(all_digits[0])
    if (last_digit < 0) {
        last_digit = all_digits && all_digits[0]
    }
    calibration_value = '' + first_digit + last_digit
    console.log(`${calibration_value} = ${first_digit} & ${last_digit} < ${line}`)
    answer += parseInt(calibration_value, 10)
    line_num++

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