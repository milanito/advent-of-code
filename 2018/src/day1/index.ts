import * as fs from 'fs'
import { reduce, split } from 'lodash'

const file = fs.readFileSync('./inputs/day1.txt', 'utf-8');

const arr = split(file, '\n')
const result = reduce(arr, (acc, line) => acc + parseInt(line), 0)

console.log(result)

const values = new Set([0])
let acc = 0
let idx = 0

while(true) {
  if (idx > arr.length - 1) {
    idx = 0
  }

  acc += parseInt(arr[idx++])

  if (values.has(acc)) {
    break
  }

  values.add(acc)
}

console.log(acc)
