/**
 * Day 11 - Advent of Code 2017
 *
 * Export a default function that takes the full input as a string and returns a string result.
 *
 * Example:
 * export default function solve(input: string): string { ... }
 */

export default function solve(input: string): string {
  const lines = input.trim().split(/\r?\n/).filter(Boolean)
  const part1 = part1Solver(lines)
  const part2 = part2Solver(lines)
  return `Part 1: ${part1}
Part 2: ${part2}`
}

interface Device {
  name: string
  output: Set<string>
}

const parseLine = (line: string): Device => {
  const data = line.split(': ')

  return {
    name: data[0],
    output: new Set(data[1].split(' '))
  }
}

const findAllPaths = (
  devices: Map<string, Set<string>>,
  start: string,
  end: string,
  currentPath: string[],
  allPaths: string[][]
): void => {
  currentPath.push(start)

  if (start === end) {
    allPaths.push([...currentPath])
  } else {
    const neighbors = devices.get(start)
    if (neighbors) {
      for (const neighbor of neighbors) {
        if (!currentPath.includes(neighbor)) {
          findAllPaths(devices, neighbor, end, currentPath, allPaths)
        }
      }
    }
  }

  currentPath.pop()
}

const countPathsDP = (
  devices: Map<string, Set<string>>,
  current: string,
  end: string,
  hasDac: boolean,
  hasFft: boolean,
  memo: Map<string, number>
): number => {
  // Encode the DP state as a string key
  const key = `${current}|${hasDac ? 1 : 0}|${hasFft ? 1 : 0}`
  if (memo.has(key)) {
    return memo.get(key)!
  }

  if (current === end) {
    const res = hasDac && hasFft ? 1 : 0
    memo.set(key, res)
    return res
  }

  let count = 0
  const neighbors = devices.get(current)

  if (neighbors) {
    for (const neighbor of neighbors) {
      const newHasDac = hasDac || neighbor === 'dac'
      const newHasFft = hasFft || neighbor === 'fft'
      count += countPathsDP(
        devices,
        neighbor,
        end,
        newHasDac,
        newHasFft,
        memo
      )
    }
  }

  memo.set(key, count)
  return count
}

const part1Solver = (lines: string[]): number => {
  const devices: Map<string, Set<string>> = new Map(
    lines.map(parseLine).map((item) => [item.name, item.output])
  )

  const allPaths: string[][] = []
  findAllPaths(devices, 'you', 'out', [], allPaths)

  return allPaths.length
}

const part2Solver = (lines: string[]): number => {
  const devices: Map<string, Set<string>> = new Map(
    lines.map(parseLine).map((item) => [item.name, item.output])
  )

  const memo = new Map<string, number>()

  // At svr we have not yet seen dac or fft
  return countPathsDP(devices, 'svr', 'out', false, false, memo)
}

if (require.main === module) {
  const fs = require("fs")
  const path = require("path")
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day11_test.txt")
  const input = fs.readFileSync(inputFile, "utf8")
  const mod = require("./day11")
  const solver = mod.default || mod.solve || mod.main
  if (typeof solver === "function") {
    const out = solver(input)
    if (out && out.then) {
      out.then((r: any) => console.log(r)).catch((e: any) => console.error(e))
    } else {
      console.log(out)
    }
  } else {
    console.error("No solver exported.")
  }
}

