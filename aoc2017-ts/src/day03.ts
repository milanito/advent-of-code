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
  const part1 = part1Solver(lines.map(it => parseInt(it))[0]);
  const part2 = lines.length;
  return `Part 1: ${part1}
Part 2: ${part2}`;
}

const part1Solver = (num: number): string => {
  let i = 1

  while (i * i < num) {
    i += 1
  }

  item = (i - 1) * (i - 1)


  if (num > item && num <= item + (i - 1)) {
  } else if (num > item + (i - 1) && num <= item + 2 * (i - 1)) {
  } else if (num > item + 2 * (i - 1) && num <= item + 3 * (i - 1)) {
  } else {
  }
  return ''
}

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
