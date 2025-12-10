/**
 * Day 10 - Advent of Code 2017
 *
 * Export a default function that takes the full input as a string and returns a string result.
 *
 * Example:
 * export default function solve(input: string): string { ... }
 */
export default function solve(input: string): string {
  const lines = input.trim().split(/\r?\n/).filter(Boolean)
  const part1 = part1Solver(lines)
  const part2 = part2Solver(lines)
  return `Part 1: ${part1}
Part 2: ${part2}`
}

interface Machine {
  target: number[]
  buttons: number[][]
}

interface MachineJoltage {
  targets: number[]
  buttons: number[][]
}

const parseMachine = (line: string): Machine => {
  const targetMatch = line.match(/\[([.#]+)\]/)
  if (!targetMatch) throw new Error("No target state found")

  const target = targetMatch[1].split('').map(c => c === '#' ? 1 : 0)

  const buttonMatches = line.matchAll(/\(([0-9,]+)\)/g)
  const buttons: number[][] = []

  for (const match of buttonMatches) {
    const indices = match[1].split(',').map(Number)
    buttons.push(indices)
  }

  return { target, buttons }
}

const parseMachineJoltage = (line: string): MachineJoltage => {
  const joltageMatch = line.match(/\{([0-9,]+)\}/)
  if (!joltageMatch) throw new Error("No joltage requirements found")

  const targets = joltageMatch[1].split(',').map(Number)

  const buttonMatches = line.matchAll(/\(([0-9,]+)\)/g)
  const buttons: number[][] = []

  for (const match of buttonMatches) {
    const indices = match[1].split(',').map(Number)
    buttons.push(indices)
  }

  return { targets, buttons }
}

const solveGF2 = (machine: Machine): number => {
  const numLights = machine.target.length
  const numButtons = machine.buttons.length

  const matrix: number[][] = []

  for (let i = 0; i < numLights; i++) {
    const row = new Array(numButtons + 1).fill(0)
    for (let j = 0; j < numButtons; j++) {
      if (machine.buttons[j].includes(i)) {
        row[j] = 1
      }
    }
    row[numButtons] = machine.target[i]
    matrix.push(row)
  }

  const pivotCols: number[] = []
  let currentRow = 0

  for (let col = 0; col < numButtons && currentRow < numLights; col++) {
    let pivotRow = -1
    for (let row = currentRow; row < numLights; row++) {
      if (matrix[row][col] === 1) {
        pivotRow = row
        break
      }
    }

    if (pivotRow === -1) continue

    if (pivotRow !== currentRow) {
      [matrix[currentRow], matrix[pivotRow]] = [matrix[pivotRow], matrix[currentRow]]
    }

    pivotCols.push(col)

    for (let row = 0; row < numLights; row++) {
      if (row !== currentRow && matrix[row][col] === 1) {
        for (let c = 0; c <= numButtons; c++) {
          matrix[row][c] ^= matrix[currentRow][c]
        }
      }
    }

    currentRow++
  }

  for (let row = currentRow; row < numLights; row++) {
    let allZero = true
    for (let col = 0; col < numButtons; col++) {
      if (matrix[row][col] !== 0) {
        allZero = false
        break
      }
    }
    if (allZero && matrix[row][numButtons] === 1) {
      return -1
    }
  }

  const freeVars: number[] = []
  for (let col = 0; col < numButtons; col++) {
    if (!pivotCols.includes(col)) {
      freeVars.push(col)
    }
  }

  const numFree = freeVars.length
  const numCombinations = 1 << numFree

  let minPresses = Infinity

  for (let combo = 0; combo < numCombinations; combo++) {
    const solution = new Array(numButtons).fill(0)

    for (let i = 0; i < numFree; i++) {
      solution[freeVars[i]] = (combo >> i) & 1
    }

    for (let i = pivotCols.length - 1; i >= 0; i--) {
      const pivotCol = pivotCols[i]
      const row = i

      let val = matrix[row][numButtons]
      for (let col = pivotCol + 1; col < numButtons; col++) {
        val ^= matrix[row][col] * solution[col]
      }
      solution[pivotCol] = val
    }

    const presses = solution.reduce((sum, x) => sum + x, 0)
    minPresses = Math.min(minPresses, presses)
  }

  return minPresses
}

const solveIntegerLP = (machine: MachineJoltage): number => {
  const m = machine.targets.length
  const n = machine.buttons.length

  const matrix: number[][] = []
  for (let i = 0; i < m; i++) {
    const row = new Array(n + 1).fill(0)
    for (let j = 0; j < n; j++) {
      if (machine.buttons[j].includes(i)) {
        row[j] = 1
      }
    }
    row[n] = machine.targets[i]
    matrix.push(row)
  }

  const pivotCols: number[] = []
  let row = 0

  for (let col = 0; col < n && row < m; col++) {
    let pivotRow = -1
    for (let r = row; r < m; r++) {
      if (matrix[r][col] !== 0) {
        pivotRow = r
        break
      }
    }

    if (pivotRow === -1) continue

    if (pivotRow !== row) {
      [matrix[row], matrix[pivotRow]] = [matrix[pivotRow], matrix[row]]
    }

    pivotCols.push(col)

    const pivot = matrix[row][col]
    for (let c = 0; c <= n; c++) {
      matrix[row][c] /= pivot
    }

    for (let r = 0; r < m; r++) {
      if (r !== row && matrix[r][col] !== 0) {
        const factor = matrix[r][col]
        for (let c = 0; c <= n; c++) {
          matrix[r][c] -= factor * matrix[row][c]
        }
      }
    }

    row++
  }

  for (let r = row; r < m; r++) {
    let allZero = true
    for (let c = 0; c < n; c++) {
      if (Math.abs(matrix[r][c]) > 1e-9) {
        allZero = false
        break
      }
    }
    if (allZero && Math.abs(matrix[r][n]) > 1e-9) {
      return Infinity
    }
  }

  const freeVars: number[] = []
  for (let col = 0; col < n; col++) {
    if (!pivotCols.includes(col)) {
      freeVars.push(col)
    }
  }

  let minSum = Infinity

  const maxTarget = Math.max(...machine.targets)
  const maxFree = maxTarget * 2

  const searchFree = (freeIdx: number, solution: number[]): void => {
    if (freeIdx === freeVars.length) {
      for (let i = 0; i < pivotCols.length; i++) {
        const pcol = pivotCols[i]
        let val = matrix[i][n]
        for (let c = 0; c < n; c++) {
          if (c !== pcol) {
            val -= matrix[i][c] * solution[c]
          }
        }
        solution[pcol] = val
      }

      let valid = true
      for (let i = 0; i < n; i++) {
        if (solution[i] < -1e-9 || Math.abs(solution[i] - Math.round(solution[i])) > 1e-9) {
          valid = false
          break
        }
      }

      if (valid) {
        const sum = solution.reduce((s, x) => s + Math.round(x), 0)
        minSum = Math.min(minSum, sum)
      }
      return
    }

    const freeCol = freeVars[freeIdx]
    for (let val = 0; val <= maxFree; val++) {
      solution[freeCol] = val

      let currentSum = 0
      for (let i = 0; i <= freeIdx; i++) {
        currentSum += solution[freeVars[i]]
      }
      if (currentSum >= minSum) break

      searchFree(freeIdx + 1, solution)

      if (minSum < Infinity && val > 0) {
        if (val > minSum / freeVars.length) break
      }
    }
  }

  const solution = new Array(n).fill(0)
  searchFree(0, solution)

  return minSum
}

const part1Solver = (lines: string[]): number => {
  let totalPresses = 0

  for (const line of lines) {
    const machine = parseMachine(line)
    const minPresses = solveGF2(machine)

    if (minPresses === -1) {
      throw new Error(`No solution for machine: ${line}`)
    }

    totalPresses += minPresses
  }

  return totalPresses
}

const part2Solver = (lines: string[]): number => {
  let totalPresses = 0

  for (const line of lines) {
    const machine = parseMachineJoltage(line)
    const minPresses = solveIntegerLP(machine)

    if (!isFinite(minPresses)) {
      throw new Error(`No solution for machine: ${line}`)
    }

    totalPresses += minPresses
  }

  return totalPresses
}

if (require.main === module) {
  const fs = require("fs")
  const path = require("path")
  const inputFile = process.argv[2] || path.join(__dirname, "..", "inputs", "day10_test.txt")
  const input = fs.readFileSync(inputFile, "utf8")
  const mod = require("./day10")
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
