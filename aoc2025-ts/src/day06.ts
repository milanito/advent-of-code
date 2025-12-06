/**
 * Day 06 - Advent of Code 2017
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

const part1Solver = (lines: string[]): number =>
  lines.reduce((acc: number[][], line: string, index: number) => {
    const trimmed = line.trim().split(/\s+/)

    if (index === 0) {
      return trimmed.map(item => [parseInt(item)])
    } else if (trimmed.includes('+')) {
      for (let i = 0; i < trimmed.length; i++) {
        if (trimmed[i] === '+') {
          acc[i] = [acc[i].reduce((acc: number, item:number): number => acc + item, 0)]
        } else {
          acc[i] = [acc[i].reduce((acc: number, item: number): number => acc * item, 1)]
        }
      }
    } else {
      for (let i = 0; i < trimmed.length; i++) {
        acc[i].push(parseInt(trimmed[i]))
      }
    }

    return acc
  }, [])
  .reduce((acc, item) => acc + item[0], 0)

const extractor = (line: string, ): string[][] => {
  let curr = []
  const total = []

  for (let i = 0; i < line.length; i++) {
    if (line[i] === ' ') {
      if (i == line.length - 1) {
        curr.push(line[i])
      } else if (line[i + 1] !== ' ' && curr.length > 0) {
        total.push(curr)
        curr = []
      } else {
        curr.push(line[i])
      }
    } else {
      curr.push(line[i])
    }
  }

  total.push(curr)

  console.log(total, line)
  return total
}

const part2Solver = (lines: string[]): number => {
  if (lines.length === 0) {
    return 0;
  }

  const height = lines.length;
  const width = Math.max(...lines.map(l => l.length));

  // Pad lines on the right so all have the same length
  const grid = lines.map(l => l.padEnd(width, " "));

  // Helper to check if a whole column is blank
  const isBlankColumn = (col: number): boolean =>
    grid.every(row => row[col] === " ");

  // Build problem regions: contiguous non-blank columns,
  // separated by at least one fully blank column
  type Region = { start: number; end: number };
  const regions: Region[] = [];
  let currentStart: number | null = null;

  for (let col = 0; col < width; col++) {
    const blank = isBlankColumn(col);
    if (blank) {
      if (currentStart !== null) {
        regions.push({ start: currentStart, end: col - 1 });
        currentStart = null;
      }
    } else {
      if (currentStart === null) {
        currentStart = col;
      }
    }
  }
  if (currentStart !== null) {
    regions.push({ start: currentStart, end: width - 1 });
  }

  // For each region, extract numbers and operator, then evaluate
  let total = 0;

  for (const region of regions) {
    const { start, end } = region;

    // Find operator in the bottom row inside this region
    const bottomRow = grid[height - 1];
    let op: "+" | "*" | null = null;

    for (let col = start; col <= end; col++) {
      const ch = bottomRow[col];
      if (ch === "+" || ch === "*") {
        op = ch;
        break;
      }
    }

    if (!op) {
      // No operator found in this region, skip it
      continue;
    }

    // Extract numbers column by column inside the region
    const numbers: number[] = [];

    for (let col = start; col <= end; col++) {
      let digits = "";

      // Only scan rows above the operator line
      for (let row = 0; row < height - 1; row++) {
        const ch = grid[row][col];
        if (ch >= "0" && ch <= "9") {
          digits += ch;
        }
      }

      if (digits.length > 0) {
        numbers.push(parseInt(digits, 10));
      }
    }

    if (numbers.length === 0) {
      continue;
    }

    const regionResult =
      op === "+"
        ? numbers.reduce((acc, n) => acc + n, 0)
        : numbers.reduce((acc, n) => acc * n, 1);

    total += regionResult;
  }

  return total;
};

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day06_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day06");
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
