lines = File.readlines('./input.txt', chomp: true)

@start = { y: 0 }
@finish = { y: lines.length - 1 }

board = lines.map.with_index do |line, idx|
  data = line.split('')

  if idx == 0
    @start[:x] = data.find_index('.')
  elsif idx == lines.length - 1
    @finish[:x] = data.find_index('.')
  end 

  data
end

created = [
  {
    items: [@start],
    finish: false
  }
]

def handle_pos(pos, items, board)
  if items.find_index { |item| item[:x] == pos[:x] && item[:y] == pos[:y] } != nil
    return -1
  end

  if pos[:y] < board.length && pos[:y] > -1 && pos[:x] < board[0].length && pos[:x] > -1 && board[pos[:y]][pos[:x]] != '#'
    if pos[:y] == @finish[:y] && pos[:x] == @finish[:x]
      return 0
    else 
      return 1
    end
  end

  return -1
end

def handle_path(paths, board)
  to_check = paths.select { |path| !path[:finish] }

  if to_check.length == 0
    return paths.select { |path| path[:finish] }.map { |path| path[:items].length }.max 
  end

  updated_paths = paths.select { |path| path[:finish] }

  to_check.each do |path|
    pos = path[:items].last
    
    if (board[pos[:y]][pos[:x]] == '.' && board[pos[:y]][pos[:x] + 1] != '<') || board[pos[:y]][pos[:x]] == '>'
      res_right = handle_pos({ x: pos[:x] + 1, y: pos[:y] }, path[:items], board)

      if res_right > -1
        path_new = path.clone
        path_new[:items].push({ x: pos[:x] + 1, y: pos[:y] })

        if res_right == 0
          path_new[:finish] = true
        end

        updated_paths.push(path_new)
      end
    end
    if (board[pos[:y]][pos[:x]] == '.' && board[pos[:y]][pos[:x] - 1] != '>') || board[pos[:y]][pos[:x]] == '<'
      res_left = handle_pos({ x: pos[:x] - 1, y: pos[:y] }, path[:items], board)

      if res_left > -1
        path_new = path.clone
        path_new[:items].push({ x: pos[:x] - 1, y: pos[:y] })

        if res_left == 0
          path_new[:finish] = true
        end

        updated_paths.push(path_new)
      end
    end
    if (board[pos[:y]][pos[:x]] == '.' && board[pos[:y] - 1][pos[:x]] != 'v') || board[pos[:y]][pos[:x]] == '^'
      res_top = handle_pos({ x: pos[:x], y: pos[:y] - 1 }, path[:items], board)

      if res_top > -1
        path_new = path.clone
        path_new[:items].push({ x: pos[:x], y: pos[:y] - 1 })

        if res_top == 0
          path_new[:finish] = true
        end

        updated_paths.push(path_new)
      end
    end
    if (board[pos[:y]][pos[:x]] == '.' && board[pos[:y] - 1][pos[:x]] != '^') || board[pos[:y]][pos[:x]] == 'v'
      res_bottom = handle_pos({ x: pos[:x], y: pos[:y] + 1 }, path[:items], board)

      if res_bottom > -1
        path_new = path.clone
        path_new[:items].push({ x: pos[:x], y: pos[:y] + 1 })

        if res_bottom == 0
          path_new[:finish] = true
        end

        updated_paths.push(path_new)
      end
    end
  end

  handle_path(updated_paths, board)
end

res = handle_path(created, board)

pp res + 1
