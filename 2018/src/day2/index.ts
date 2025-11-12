import * as fs from 'fs'
import { reduce, split, forEach, join } from 'lodash'

const file = fs.readFileSync('./inputs/day2.txt', 'utf-8');

const arr = split(file, '\n').sort((one, two) => (one > two ? -1 : 1));

const res = reduce(reduce(arr, (acc, it) => {
  const letters = reduce(split(it, ''), (acc, letter) => ({
    ...acc,
    [letter]: (acc[letter] ?? 0) + 1
  }), {})

  let varTwo = false
  let varThree = false
  forEach(letters, (value) => {
    if (value === 2 && !varTwo) {
      acc[2] += 1
      varTwo = true
    }
    if (value === 3 && !varThree) {
      acc[3] += 1
      varThree = true
    }
  })

  return acc
}, {
    2: 0, 3: 0
  }), (acc, value) => acc * value, 1)

console.log(res)

const data = reduce(arr, (acc, it, idx) => {
  if (idx < arr.length - 1) {
    const next = arr[idx + 1]

    const diff = reduce(it.split(''), (acc, letter, counter) => {
      if (letter !== next[counter]) {
        acc += 1
      }

      return acc
    }, 0)

    if (diff < acc.differences) {
      return {
        first: idx,
        differences: diff
      }
    }
  }

  return acc
}, { first: -1, differences: arr[0].length + 1})

const res2 = join(reduce(split(arr[data.first], ''), (acc, it, idx) => {
  if (it === arr[data.first + 1][idx]) {
    acc.push(it)
  }

  return acc
}, []), '')

console.log(res2)
