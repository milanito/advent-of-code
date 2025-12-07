/**
 * Day 07 - Advent of Code 2017
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

const part1Solver = (lines: string[]): number => {
  const grid = lines.map(line => line.split(''))
  let beams:string[] = []
  let count = 0
  let i = 0

  while (i < grid[0].length && beams.length === 0) {
    if (grid[0][i] === 'S') {
      beams.push(`0-${i}`)
    }
    ++i
  }

  i = 0

  while(i < grid.length - 1) {
    const updated: string[] = []

    beams.forEach(beam => {
      const [row, col] = beam.split('-').map(it => parseInt(it))

      if (grid[row + 1][col] === '.') {
        updated.push(`${row + 1}-${col}`)
      } else {
        count++
        updated.push(`${row + 1}-${col - 1}`)
        updated.push(`${row + 1}-${col + 1}`)
      }
    })
    beams = [...new Set(updated)]
    ++i
  }


  return count
}

const part2Solver = (lines: string[]): number => {
  const grid = lines.map(line => line.split(''))
  let count = 0
  let i = 0
  let start: number[] = []

  while (i < grid[0].length && start.length === 0) {
    if (grid[0][i] === 'S') {
      start = [0, i]
    }
    ++i
  }

  const res = new Array(grid[0].length).fill(1);

  i = grid.length - 1

  while (i >= 0) {
    grid[i].forEach((it: string, idx: number): void => {
      if (it === '^') {
        res[idx] = res[idx - 1] + res[idx + 1]
      }
    })

    --i
  }

  return res[start[1]]
}

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day07_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day07");
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
