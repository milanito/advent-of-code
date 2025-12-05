/**
 * Day 05 - Advent of Code 2017
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

const range = (size:number, startAt:number = 0):ReadonlyArray<number> => {
    return [...Array(size).keys()].map(i => i + startAt);
}

const part1Solver = (lines: string[]): number => {
  const availables:number[][] = []
  let count = 0
  lines.forEach(line => {
    if (line.includes('-')) {
      const [start, end] = line.split('-')

      availables.push([parseInt(start), parseInt(end)])

    } else if (line !== '\n'){
      const num = parseInt(line)

      let avail = false
      let i = 0

      while (i < availables.length && !avail) {
        if (num >= availables[i][0] && num <= availables[i][1]) {
          avail = true
        }
        i++
      }

      if (avail) {
        count++
      }
    }
  })

  return count
}

const part2Solver = (lines: string[]): number =>
  lines.reduce((acc: number[][], line: string): number[][] => {
    if (line.includes('-')) {
      const [start, end] = line.split('-')

      acc.push([parseInt(start), parseInt(end)])
      return acc

    } else {
      return acc
    }
  }, [])
  .sort((a: number[], b: number[]) => a[0] - b[0])
  .reduce((acc: number[][], item: number[], idx: number) => {
    if (idx == 0) {
      return [item]
    }
  
    const last = acc[acc.length - 1]

    if (last[1] >= item[0]) {
      acc = acc.slice(0, -1)
      acc.push([Math.min(last[0], item[0]), Math.max(item[1], last[1])])
    } else {
      acc.push(item)
    }

    return acc
  }, [])
  .reduce((acc: number, item: number[]) => acc + (item[1] - item[0] + 1), 0)

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day05_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day05");
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
