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
  const part1 = part1Solver(lines[0]);
  const part2 = part2Solver(lines[0]);
  return `Part 1: ${part1}
Part 2: ${part2}`;
}

const part1Solver = (line: string):number => {
  return line.split(',')
  .map((item) => item.split('-'))
  .filter(items => items.length == 2)
  .map((items) => [
      ...Array(parseInt(items[1]) - parseInt(items[0]) + 1).keys()
    ].map(i => i + parseInt(items[0])))
  .flat()
  .map(item => item.toString())
  .reduce((acc: number, el: string): number => {
    if (el.length % 2 != 0) {
      return acc
    }

    let i = 0
    let j = el.length / 2

    while (j < el.length) {
      if (el[i] != el[j]) {
        return acc
      }

      i++
      j++
    }

    return acc + parseInt(el)
  }, 0)
}

const part2Solver = (line: string):number => {
  return line.split(',')
  .map((item) => item.split('-'))
  .filter(items => items.length == 2)
  .map((items) => [
      ...Array(parseInt(items[1]) - parseInt(items[0]) + 1).keys()
    ].map(i => i + parseInt(items[0])))
  .flat()
  .map(item => item.toString())
  .reduce((acc: number, el: string): number => {
    if (isInvalidId(el)) {
      return acc + parseInt(el)
    }

    return acc
  }, 0)
}

const isInvalidId = (id: string): boolean  => {
  const n = id.length;

  for (let size = 1; size <= Math.floor(n / 2); size++) {
    if (n % size === 0) {
      const block = id.slice(0, size);
      if (block.repeat(n / size) === id) {
        return true;
      }
    }
  }
  return false;
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
