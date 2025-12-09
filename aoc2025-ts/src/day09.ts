/**
 * Day 09 - Advent of Code 2017
 *
 * Export a default function that takes the full input as a string and returns a string result.
 *
 * Example:
 * export default function solve(input: string): string { ... }
 */

export default function solve(input: string): string {
  const lines = input.trim().split(/\r?\n/).filter(Boolean)
  // Replace with your solution logic
  const part1 = part1Solver(lines)
  const part2 = part2Solver(lines)
  return `Part 1: ${part1}
Part 2: ${part2}`
}

type Point = {
  X: number,
  Y: number
}

type HorizontalEdge = {
  y: number
  x1: number
  x2: number
}

type VerticalEdge = {
  x: number
  y1: number
  y2: number
}

type Interval = {
  from: number
  to: number
}

const parsePoints = (lines: string[]): Point[] =>
  lines.map((line: string): Point => {
    const [x, y] = line.split(",")
    return {
      X: parseInt(x, 10),
      Y: parseInt(y, 10),
    }
  })

const part1Solver = (lines: string[]): number => {
  const items: Point[] = parsePoints(lines)

  let maxArea = -1

  for (let i = 0; i < items.length - 1; i++) {
    for (let j = i + 1; j < items.length; j++) {
      const area = (Math.abs(items[i].X - items[j].X) + 1) * (Math.abs(items[i].Y - items[j].Y) + 1)

      if (area > maxArea) {
        maxArea = area
      }
    }
  }

  return maxArea
}

const buildEdges = (points: Point[]): {
  horizontals: HorizontalEdge[]
  verticals: VerticalEdge[]
} => {
  const horizontals: HorizontalEdge[] = []
  const verticals: VerticalEdge[] = []

  const n = points.length
  for (let i = 0; i < n; i++) {
    const p = points[i]
    const q = points[(i + 1) % n]

    if (p.X === q.X) {
      // vertical edge
      const x = p.X
      const y1 = Math.min(p.Y, q.Y)
      const y2 = Math.max(p.Y, q.Y)
      if (y1 !== y2) {
        verticals.push({ x, y1, y2 })
      }
    } else if (p.Y === q.Y) {
      // horizontal edge
      const y = p.Y
      const x1 = Math.min(p.X, q.X)
      const x2 = Math.max(p.X, q.X)
      if (x1 !== x2) {
        horizontals.push({ y, x1, x2 })
      }
    } else {
      throw new Error("Non axis aligned edge in input")
    }
  }

  return { horizontals, verticals }
}

const mergeIntervals = (segments: { from: number; to: number }[]): Interval[] => {
  if (segments.length === 0) return []
  segments.sort((a, b) => a.from - b.from)
  const merged: Interval[] = []
  let current = { ...segments[0] }

  for (let i = 1; i < segments.length; i++) {
    const s = segments[i]
    if (s.from <= current.to) {
      current.to = Math.max(current.to, s.to)
    } else {
      merged.push(current)
      current = { ...s }
    }
  }
  merged.push(current)
  return merged
}

const buildVerticalAllowed = (
  xs: number[],
  horizontals: HorizontalEdge[],
  verticals: VerticalEdge[]
): Map<number, Interval[]> => {
  const allowed = new Map<number, Interval[]>()

  for (const x0 of xs) {
    const segments: { from: number; to: number }[] = []

    // interior segments from horizontal edges crossing this x
    const crossings: number[] = []
    for (const h of horizontals) {
      if (h.x1 <= x0 && x0 < h.x2) {
        crossings.push(h.y)
      }
    }
    crossings.sort((a, b) => a - b)
    for (let i = 0; i + 1 < crossings.length; i += 2) {
      segments.push({ from: crossings[i], to: crossings[i + 1] })
    }

    // boundary vertical edges lying exactly on x0
    for (const v of verticals) {
      if (v.x === x0) {
        segments.push({ from: v.y1, to: v.y2 })
      }
    }

    allowed.set(x0, mergeIntervals(segments))
  }

  return allowed
}

const buildHorizontalAllowed = (
  ys: number[],
  horizontals: HorizontalEdge[],
  verticals: VerticalEdge[]
): Map<number, Interval[]> => {
  const allowed = new Map<number, Interval[]>()

  for (const y0 of ys) {
    const segments: { from: number; to: number }[] = []

    // interior segments from vertical edges crossing this y
    const crossings: number[] = []
    for (const v of verticals) {
      if (v.y1 <= y0 && y0 < v.y2) {
        crossings.push(v.x)
      }
    }
    crossings.sort((a, b) => a - b)
    for (let i = 0; i + 1 < crossings.length; i += 2) {
      segments.push({ from: crossings[i], to: crossings[i + 1] })
    }

    // boundary horizontal edges lying exactly on y0
    for (const h of horizontals) {
      if (h.y === y0) {
        segments.push({ from: h.x1, to: h.x2 })
      }
    }

    allowed.set(y0, mergeIntervals(segments))
  }

  return allowed
}

const rangeInside = (a: number, b: number, intervals: Interval[] | undefined): boolean => {
  if (!intervals || intervals.length === 0) return false
  let from = a
  let to = b
  if (from > to) {
    const tmp = from
    from = to
    to = tmp
  }
  for (const iv of intervals) {
    if (iv.from <= from && to <= iv.to) {
      return true
    }
  }
  return false
}

const part2Solver = (lines: string[]): number => {
  const points = parsePoints(lines)
  const n = points.length

  const { horizontals, verticals } = buildEdges(points)

  const xs = Array.from(new Set(points.map((p) => p.X))).sort((a, b) => a - b)
  const ys = Array.from(new Set(points.map((p) => p.Y))).sort((a, b) => a - b)

  const allowedYByX = buildVerticalAllowed(xs, horizontals, verticals)
  const allowedXByY = buildHorizontalAllowed(ys, horizontals, verticals)

  let maxArea = -1

  for (let i = 0; i < n; i++) {
    const p = points[i]
    for (let j = i + 1; j < n; j++) {
      const q = points[j]

      if (p.X === q.X && p.Y === q.Y) continue

      const xa = Math.min(p.X, q.X)
      const xb = Math.max(p.X, q.X)
      const ya = Math.min(p.Y, q.Y)
      const yb = Math.max(p.Y, q.Y)

      const area = (xb - xa + 1) * (yb - ya + 1)

      // pruning
      if (area <= maxArea) continue

      const v1 = allowedYByX.get(xa)
      const v2 = allowedYByX.get(xb)
      const h1 = allowedXByY.get(ya)
      const h2 = allowedXByY.get(yb)

      if (!rangeInside(ya, yb, v1)) continue
      if (!rangeInside(ya, yb, v2)) continue
      if (!rangeInside(xa, xb, h1)) continue
      if (!rangeInside(xa, xb, h2)) continue

      maxArea = area
    }
  }

  return maxArea
}

if (require.main === module) {
  const fs = require("fs")
  const path = require("path")
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day09_test.txt")
  const input = fs.readFileSync(inputFile, "utf8")
  const mod = require("./day09")
  const solver = mod.default || mod.solve || mod.main
  if (typeof solver === "function") {
    const out = solver(input)
    if (out && out.then) {
      out.then((r: any) => console.log(r)).catch((e: any) => console.error(e))
    } else {
      console.log(out)
    }
  } else {
    console.error("No solver exported.")
  }
}
