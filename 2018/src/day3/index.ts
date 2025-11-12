import * as fs from 'fs'
import { reduce, split, last, map, first, forEach } from 'lodash'

const file = fs.readFileSync('./inputs/day3.txt', 'utf-8');

const arr = split(file, '\n')

let counter = 0
const board = reduce(arr, (acc, it) => {
  const data = split(last(split(it, ' @ ')), ': ')
  const [x, y] = map(split(data[0], ','), it => parseInt(it)) 
  const [length, height] = map(split(data[1], 'x'), it => parseInt(it)) 

  for (var i = 0; i < height; i++) {
    for (var j = 0; j < length; j++) {
      if (acc[`${x + j}, ${y + i}`] === 1) {
        counter += 1
        acc[`${x + j}, ${y + i}`] += 1
      } else if (acc[`${x + j}, ${y + i}`] >= 1) {
        acc[`${x + j}, ${y + i}`] += 1
      } else {
        acc[`${x + j}, ${y + i}`] = 1
      }
    }
  }

  return acc
}, {})

console.log(counter)

const alone = new Set()

const board2 = reduce(arr, (acc, it) => {
  const id = parseInt(first(split(it, ' @ ')).substring(1))
  const data = split(last(split(it, ' @ ')), ': ')
  const [x, y] = map(split(data[0], ','), it => parseInt(it)) 
  const [length, height] = map(split(data[1], 'x'), it => parseInt(it)) 

  let isAlone = true

  for (var i = 0; i < height; i++) {
    for (var j = 0; j < length; j++) {
      if (!acc[`${x + j}, ${y + i}`]) {
        acc[`${x + j}, ${y + i}`] = [id]
      } else {
        isAlone = false
        acc[`${x + j}, ${y + i}`].push(id)
        forEach(acc[`${x + j}, ${y + i}`], it => alone.delete(it))
      }
    }
  }

  if (isAlone) {
    alone.add(id)
  }

  return acc
}, {})

console.log(alone)
