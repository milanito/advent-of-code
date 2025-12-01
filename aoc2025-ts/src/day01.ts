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
  const part1 = solvePart1(lines);
  const part2 = solvePart2(lines);
  return `Part 1: ${part1}
Part 2: ${part2}`;
}

const solvePart1 = (lines: string[]): number => {
  let count = 0

  lines.reduce((acc, el) => {
    const num = parseInt(el.substring(1))

    if (el[0] === 'L') {
      acc = (acc - num) % 100
    } else {
      acc = (acc + num) % 100
    }

    if (acc === 0) {
      count += 1
    }

    return acc
  }, 50);

  return count
}

const solvePart2 = (lines: string[]): number => {
  let count = 0

  lines.reduce((acc, el) => {
    const num = parseInt(el.substring(1))
    const isPos = acc > 0

    const div = ~~(Math.abs(num) / 100)
    const rest = Math.abs(num) % 100
    count += div

    if (el[0] === 'L') {
      acc = (acc - rest) % 100
      
      if (isPos && acc <= 0) {
        count += 1
      }
    } else {
      acc = (acc + rest)

      if (acc > 99) {
        count += 1
      }

      acc %= 100
    }

    if (acc === 0) {
      count += 1
    }

    return acc
  }, 50);

  return count
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
