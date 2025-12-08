/**
 * Day 08 - Advent of Code 2017
 *
 * Export a default function that takes the full input as a string and returns a string result.
 *
 * Example:
 * export default function solve(input: string): string { ... }
 */

export default function solve(input: string): string {
  const lines = input.trim().split(/\r?\n/).filter(Boolean);

  const part1 = part1Solver(lines);
  const part2 = part2Solver(lines);

  return `Part 1: ${part1}
Part 2: ${part2}`;
}

type Coordinate = { X: number; Y: number; Z: number };
type Edge = { a: number; b: number; dist: number };

const parseCoordinates = (lines: string[]): Coordinate[] =>
  lines.map((line: string): Coordinate => {
    const data = line.split(",");
    return {
      X: parseInt(data[0], 10),
      Y: parseInt(data[1], 10),
      Z: parseInt(data[2], 10),
    };
  });

const squaredDistance = (first: Coordinate, second: Coordinate): number => {
  const dx = first.X - second.X;
  const dy = first.Y - second.Y;
  const dz = first.Z - second.Z;
  return dx * dx + dy * dy + dz * dz;
};

const buildEdges = (coords: Coordinate[]): Edge[] => {
  const edges: Edge[] = [];
  for (let i = 0; i < coords.length - 1; i++) {
    for (let j = i + 1; j < coords.length; j++) {
      edges.push({
        a: i,
        b: j,
        dist: squaredDistance(coords[i], coords[j]),
      });
    }
  }
  edges.sort((e1, e2) => e1.dist - e2.dist);
  return edges;
};

const runKruskalParts = (
  coords: Coordinate[],
  edges: Edge[]
): { part1: number; part2: number } => {
  const n = coords.length;
  if (n === 0) {
    return { part1: 0, part2: 0 };
  }

  const parent: number[] = Array.from({ length: n }, (_, i) => i);
  const size: number[] = Array(n).fill(1);

  const find = (x: number): number => {
    let root = x;
    while (parent[root] !== root) {
      root = parent[root];
    }
    // Path compression
    while (parent[x] !== x) {
      const next = parent[x];
      parent[x] = root;
      x = next;
    }
    return root;
  };

  const unite = (x: number, y: number): boolean => {
    let rx = find(x);
    let ry = find(y);
    if (rx === ry) return false;

    // Union by size
    if (size[rx] < size[ry]) {
      [rx, ry] = [ry, rx];
    }
    parent[ry] = rx;
    size[rx] += size[ry];
    return true;
  };

  let merges = 0;
  let part1Value: number | null = null;
  let part2Value: number | null = null;

  for (let i = 0; i < edges.length; i++) {
    if (i === 1000 && part1Value === null) {
      const componentSizes = new Array(n).fill(0);
      for (let v = 0; v < n; v++) {
        const root = find(v);
        componentSizes[root] += 1;
      }
      const sizes = componentSizes.filter((s) => s > 0).sort((a, b) => a - b);
      if (sizes.length < 3) {
        throw new Error("Not enough components to compute part 1");
      }
      part1Value =
        sizes[sizes.length - 1] *
        sizes[sizes.length - 2] *
        sizes[sizes.length - 3];
    }

    const edge = edges[i];
    if (unite(edge.a, edge.b)) {
      merges += 1;

      if (merges === n - 1) {
        part2Value = coords[edge.a].X * coords[edge.b].X;
        break;
      }
    }
  }

  if (part1Value === null) {
    const componentSizes = new Array(n).fill(0);
    for (let v = 0; v < n; v++) {
      const root = find(v);
      componentSizes[root] += 1;
    }
    const sizes = componentSizes.filter((s) => s > 0).sort((a, b) => a - b);
    if (sizes.length < 3) {
      throw new Error("Not enough components to compute part 1");
    }
    part1Value =
      sizes[sizes.length - 1] *
      sizes[sizes.length - 2] *
      sizes[sizes.length - 3];
  }

  if (part2Value === null) {
    throw new Error("Graph did not become fully connected, cannot compute part 2");
  }

  return { part1: part1Value, part2: part2Value };
};

const part1Solver = (lines: string[]): number => {
  const coords = parseCoordinates(lines);
  const edges = buildEdges(coords);
  return runKruskalParts(coords, edges).part1;
};

const part2Solver = (lines: string[]): number => {
  const coords = parseCoordinates(lines);
  const edges = buildEdges(coords);
  return runKruskalParts(coords, edges).part2;
};

if (require.main === module) {
  const fs = require("fs");
  const path = require("path");
  const inputFile =
    process.argv[2] || path.join(__dirname, "..", "inputs", "day08_test.txt");
  const input = fs.readFileSync(inputFile, "utf8");
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const mod = require("./day08");
  const solver = mod.default || mod.solve || mod.main;
  if (typeof solver === "function") {
    const out = solver(input);
    if (out && out.then) {
      out
        .then((r: any) => console.log(r))
        .catch((e: any) => console.error(e));
    } else {
      console.log(out);
    }
  } else {
    console.error("No solver exported.");
  }
}
