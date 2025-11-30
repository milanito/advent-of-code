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

const part1Solver = (lines: string[]): number => {
  return lines.map(line => {
    return line.split(' ').reduce((acc, word) => {
      if (!acc.valid) {
        return acc
      }

      if (acc.wordsSet.has(word)) {
        return {
          ...acc, valid: false
        }
      }

      acc.wordsSet.add(word)

      return acc
    }, {
      wordsSet: new Set(),
      valid: true
    }) 
  }).reduce((acc, line) => {
    if (line.valid) {
      return acc + 1
    }
    return acc
  }, 0)
}

const part2Solver = (lines: string[]): number => {
  return lines.map(line => {
    return line.split(' ')
      .map(word => word.split('').sort((one, two) => (one > two ? -1 : 1)).join(''))
      .reduce((acc, word) => {
      if (!acc.valid) {
        return acc
      }

      if (acc.wordsSet.has(word)) {
        return {
          ...acc, valid: false
        }
      }

      acc.wordsSet.add(word)

      return acc
    }, {
      wordsSet: new Set(),
      valid: true
    }) 
  }).reduce((acc, line) => {
    if (line.valid) {
      return acc + 1
    }
    return acc
  }, 0)
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
