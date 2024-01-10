require 'matrix'

items = File.readlines('./input.txt', chomp: true).map { |it| it.split(' ') }

current = {x: 0, y: 0}
board = Matrix.build(1000, 1000) { |i, j| i == current[:x] && j == current[:y] ? '#' : '.' }

def is_inside(mat, i, j)
  return 1 if mat[j, i] == '#'

  right = false
  left = false
  top = false
  bottom = false

  counter = i

  while counter < mat.column_count
    if mat[j, counter] == '#'
      right = true
      counter = i
      break
    end
    counter += 1
  end

  return 0 if right == false

  while counter >-1 
    if mat[j, counter] == '#'
      left = true
      counter = j
      break
    end
    counter -= 1
  end

  return 0 if left == false

  while counter < mat.row_count
    if mat[counter, i] == '#'
      bottom = true
      counter = j
      break
    end
    counter += 1
  end

  return 0 if bottom == false

  while counter > -1 
    if mat[counter, i] == '#'
      return 1
    end
    counter -= 1
  end

  return 0
end

items.each do |it|
  dir = it[0]
  tot = it[1].to_i

  (1..tot).each do |idx|
    case dir
    when 'U'
      board[current[:y] - idx, current[:x]] = '#'
    when 'D'
      board[current[:y] + idx, current[:x]] = '#'
    when 'R'
      board[current[:y], current[:x] + idx] = '#'
    when 'L'
      board[current[:y], current[:x] - idx] = '#'
    end
  end

  case dir
  when 'U'
    current[:y] -= tot
  when 'D'
    current[:y] += tot
  when 'R'
    current[:x] += tot
  when 'L'
    current[:x] -= tot
  end
end

total = 0

(0...board.column_count).each do |column|
  (0...board.row_count).each do |row|
    res = is_inside(board, column, row)
    total += res
  end
end

pp total
