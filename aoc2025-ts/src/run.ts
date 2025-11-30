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
