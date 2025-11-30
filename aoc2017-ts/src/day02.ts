/**
 * Day 02 - Advent of Code 2017
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
  return lines.reduce((acc: number, line: string): number => {
    const items = line
    .trim().split(/\s+/)
    .map(it => parseInt(it))
    .sort((a: number, b:number): number => a - b)

    return acc + (items[items.length - 1] - items[0])
  }, 0)
}

const part2Solver = (lines: string[]): number => {
  return lines.reduce((acc: number, line: string): number => {
    const items = line
    .trim().split(/\s+/)
    .map(it => parseInt(it))
    .sort((a: number, b:number): number => a - b)

    for (let idx = 0; idx < items.length - 2; idx++) {
      for (let st = items.length - 1; st > idx; st--) {
        if (items[st] % items[idx] === 0) {
          acc += (items[st] / items[idx])
        }
      }
    }

    return acc
  }, 0)
}

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day02_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day02");
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
