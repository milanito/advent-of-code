# Advent of Code 2017 - TypeScript Node project

Usage:

- Install dependencies (already done by bootstrap):
  `npm install`

- Run a day:
  `npm run day -- 1 test`
  `npm run day -- 01 input`

Each day file is `src/dayNN.ts` and should export a default function:
`export default function solve(input: string): string { ... }`

The runner `src/run.ts` will load the correct input file from `inputs/dayNN.txt` or `inputs/dayNN_test.txt` and print the result.
