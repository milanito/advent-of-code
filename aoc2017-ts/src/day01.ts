/**
 * Day 01 - Advent of Code 2017
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

const part2Solver = (lines: string[]): number => {
  const items = lines[0].split('').map(it => parseInt(it))
  const total = items.length / 2
  
  let res = 0

  for (let index = 0; index < items.length; ++index) {
    let next = (index + total) % items.length

    if (items[index] === items[next]) {
      res += items[index]
    }
  }

  return res
}

const part1Solver = (lines: string[]): number => {
  const items = lines[0].split('').map(it => parseInt(it))
  
  let res = 0

  for (let index = 0; index < items.length; ++index) {
    let next = 0
    if (index !== items.length - 1) {
      next = index + 1
    }

    if (items[index] === items[next]) {
      res += items[index]
    }
  }

  return res
}

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day01_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day01");
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
