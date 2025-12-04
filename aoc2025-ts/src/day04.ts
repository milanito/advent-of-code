/**
 * Day 04 - Advent of Code 2017
 *
 * Export a default function that takes the full input as a string and returns a string result.
 *
 * Example:
 * export default function solve(input: string): string { ... }
 */

export default function solve(input: string): string {
  const lines = input.trim().split(/\r?\n/).filter(Boolean);
  // Replace with your solution logic
  const part1 = part1Solver(lines);
  const part2 = part2Solver(lines);
  return `Part 1: ${part1}
Part 2: ${part2}`;
}

const prettyPrint = (grid:string[][]): void => {
  grid.forEach(v=>console.log(...v))
  console.log('========')
}

const constructGrid = (lines:string[]): string[][] => 
  lines.map((line:string) => line.split(''))

const isRoll = (grid: string[][], row:number, col:number) =>
  !(row < 0 || row >= grid.length || col < 0 || col >= grid[0].length || grid[row][col] === '.')

const checkItem = (grid:string[][], row:number, col:number) => {
  if (grid[row][col] != '@') {
    return false
  }

  let i = 0
  let count = 0
  const directions = [[0, 1], [1, 0], [1, 1], [0, -1], [-1, 0], [-1, -1], [1, -1], [-1, 1]]

  while (i < directions.length && count < 4) {
    const [drow, dcol] = directions[i] 
    const nrow = row + drow
    const ncol = col + dcol

    if (isRoll(grid, nrow, ncol)) {
      count += 1
    }

    ++i
  }

  return count < 4
}

const part1Solver = (lines:string[]): number => {
  const grid = constructGrid(lines)
  const newGrid = constructGrid(lines)

  let i = 0
  let count = 0

  while (i < grid.length) {
    let j = 0
    while (j < grid[0].length) {
      if (checkItem(grid, i, j)) {
        count += 1
        newGrid[i][j] = 'X'
      }
      ++j
    }
    ++i
  }

  return count
}

const part2Solver = (lines:string[]): number => {
  const grid = constructGrid(lines)

  let count = 0
  let hasRemoved = []

  do {
    for (let index = 0; index < hasRemoved.length; ++index) {
      const [row, col] = hasRemoved[index]
      grid[row][col] = '.'
    }

    hasRemoved = []

    // prettyPrint(grid)

    let i = 0
    while (i < grid.length) {
      let j = 0
      while (j < grid[0].length) {
        if (checkItem(grid, i, j)) {
          count += 1
          hasRemoved.push([i, j])
        }
        ++j
      }
      ++i
    }
  } while (hasRemoved.length > 0)

  return count
}

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day04_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day04");
  const solver = mod.default || mod.solve || mod.main;
  if (typeof solver === "function") {
    const out = solver(input);
    if (out && out.then) {
      out.then((r: any) => console.log(r)).catch((e: any) => console.error(e));
    } else {
      console.log(out);
    }
  } else {
    console.error("No solver exported.");
  }
}
