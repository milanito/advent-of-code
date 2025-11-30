#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${1:-aoc2017-ts}"
echo "Creating project: $PROJECT_NAME"

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize npm if necessary
if [ ! -f package.json ]; then
  npm init -y >/dev/null
fi

# Install dev dependencies
echo "Installing devDependencies: typescript, ts-node, @types/node..."
npm install --save-dev typescript ts-node @types/node >/dev/null

# Create folders
mkdir -p src inputs

# Write tsconfig.json
cat > tsconfig.json <<'TSJSON'
{
  "compilerOptions": {
    "target": "ES2019",
    "module": "commonjs",
    "rootDir": "src",
    "outDir": "dist",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"]
}
TSJSON

# .gitignore
cat > .gitignore <<'GITIGNORE'
node_modules/
dist/
.env
.DS_Store
GITIGNORE

# Create a helpful README
cat > README.md <<'MD'
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
MD

# Create src/run.ts runner
cat > src/run.ts <<'RUNTS'
import { readFileSync } from "fs";
import { join } from "path";

function pad(n: number): string {
  return n < 10 ? `0${n}` : `${n}`;
}

function parseArgs(): { day: string; mode: "test" | "input" } {
  const raw = process.argv.slice(2);
  if (raw.length === 0) {
    console.error("Usage: npm run day -- <day> [test|input]");
    process.exit(1);
  }
  let dayArg = raw[0];
  dayArg = dayArg.replace(/^day/i, "");
  const dayNum = parseInt(dayArg, 10);
  if (isNaN(dayNum) || dayNum < 1 || dayNum > 25) {
    console.error("Invalid day. Provide a number between 1 and 25.");
    process.exit(1);
  }
  const mode = (raw[1] || "test").toLowerCase() === "input" ? "input" : "test";
  return { day: pad(dayNum), mode };
}

async function main() {
  const { day, mode } = parseArgs();
  const inputFile = join(__dirname, "..", "inputs", `day${day}${mode === "test" ? "_test" : ""}.txt`);

  let input: string;
  try {
    input = readFileSync(inputFile, "utf8");
  } catch (err) {
    console.error(`Could not read input file: ${inputFile}`);
    console.error("Make sure the file exists and contains the input.");
    process.exit(1);
    return;
  }

  const modulePath = `./day${day}`;
  try {
    // dynamic import compatible with ts-node
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const dayModule = require(modulePath);
    const solver = dayModule && (dayModule.default || dayModule.solve || dayModule.main);
    if (typeof solver !== "function") {
      console.error(`Day module ${modulePath} does not export a default function or 'solve' function.`);
      console.error("Expected: export default function solve(input: string): string");
      process.exit(1);
    }
    const result = solver(input);
    if (result instanceof Promise) {
      const awaited = await result;
      console.log(awaited);
    } else {
      console.log(result);
    }
  } catch (err: any) {
    console.error(`Failed to load or run module ${modulePath}:`, err.message || err);
    process.exit(1);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
RUNTS

# Create 25 day templates and inputs
for i in $(seq 1 25); do
  dd=$(printf "%02d" "$i")
  file="src/day${dd}.ts"
  if [ ! -f "$file" ]; then
    cat > "$file" <<EOF
/**
 * Day ${dd} - Advent of Code 2017
 *
 * Export a default function that takes the full input as a string and returns a string result.
 *
 * Example:
 * export default function solve(input: string): string { ... }
 */

export default function solve(input: string): string {
  const lines = input.trim().split(/\\r?\\n/).filter(Boolean);
  // Replace with your solution logic
  const part1 = lines.length;
  const part2 = lines.length;
  return \`Part 1: \${part1}
Part 2: \${part2}\`;
}

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day${dd}_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  const mod = require("./day${dd}");
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
EOF
  fi

  testInput="inputs/day${dd}_test.txt"
  realInput="inputs/day${dd}.txt"
  if [ ! -f "$testInput" ]; then
    cat > "$testInput" <<TXT
# day${dd} test input
# Replace this with the sample input from Advent of Code Day ${i} 2017
TXT
  fi
  if [ ! -f "$realInput" ]; then
    cat > "$realInput" <<TXT
# day${dd} real input
# Put your puzzle input here
TXT
  fi
done

# Update package.json with scripts
node -e "
const fs = require('fs');
const p = JSON.parse(fs.readFileSync('package.json','utf8'));
p.scripts = p.scripts || {};
p.scripts['build'] = 'tsc';
p.scripts['day'] = 'ts-node src/run.ts';
p.scripts['start'] = 'npm run day';
p.scripts['lint'] = 'echo \"No linter configured\"';
fs.writeFileSync('package.json', JSON.stringify(p, null, 2));
console.log('package.json scripts set: build, day, start');
"

echo "Bootstrap complete."
echo
echo "Usage examples:"
echo "  npm run day -- 1 test   # run day01 with test input"
echo "  npm run day -- 01 input # run day01 with real input"
echo
echo "Happy coding!"
