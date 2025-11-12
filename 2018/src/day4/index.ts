import * as fs from 'fs'
import { reduce, split } from 'lodash'

const file = fs.readFileSync('./inputs/day4.txt', 'utf-8');

const arr = split(file, '\n')

const sorted = arr 
  .map(line => {
    const datePart = line.slice(1, 17)
    const date = new Date(datePart.replace(" ", "T"))
    return { date, line }
  })
  .sort((a, b) => a.date - b.date)
  .map(item => item.line)

console.log(sorted)
