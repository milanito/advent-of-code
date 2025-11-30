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
  const part1 = part1Solver(lines.map(it => parseInt(it)));
  const part2 = part2Solver(lines.map(it => parseInt(it)));
  return `Part 1: ${part1}
Part 2: ${part2}`;
}

const part1Solver = (jumps: number[]): number => {
  let index = 0
  let count = 0

  while (index < jumps.length) {
    const previous = index
    index += jumps[index]
    jumps[previous] += 1
    count++
  }

  return count
}

const part2Solver = (jumps: number[]): number => {
  let index = 0
  let count = 0

  while (index < jumps.length) {
    const previous = index
    index += jumps[index]
    if (jumps[previous] >= 3) {
      jumps[previous] -= 1
    } else {
      jumps[previous] += 1
    }
    count++
  }

  return count
}

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
