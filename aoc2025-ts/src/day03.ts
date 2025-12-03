/**
 * Day 03 - Advent of Code 2017
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

const solver = (num:number) => (lines: string[]): number =>
  lines
  .map(line => line.split('').map(item => parseInt(item)))
  .reduce((acc, line, index) => {
    let count = 0
    let result = []
    while (count < line.length && result.length < num) {
      const res = getMax(line.slice(count, line.length - num + result.length + 1))
      result.push(res.max)

      if (line.length - res.index === num - result.length) {
        count = line.length
      } else {
        count += res.index + 1
      }
    }


    if (result.length < num) {
      result = result.concat(line.slice(line.length - 1 - result.length))
    }

    return acc + parseInt(result.join(''))
  }, 0)

const getMax = (list: number[]) => 
  list.reduce((acc, item, index) => {
    if (item > acc.max) {
      return {
        max: item, index
      }
    }

    return acc
  }, {max: 0, index: -1})

const part1Solver = solver(2)
const part2Solver = solver(12)

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day03_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day03");
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
