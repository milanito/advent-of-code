board = []
numbers = []
minX = 0
maxX = 0
minY = 0
maxY = 0

def checkItem(item)
  return !item.match?(/[[:digit:]]/) && item != '.'
end

File.open('input.txt').each_with_index do |line, idy|
  maxY = idy
  if maxX == 0
    maxX = line.delete("\n").length
  end
  board.push line.delete("\n").split('')
  current = []
  line.split('').each_with_index do |item, idx|
    if item.match?(/[[:digit:]]/)
      current.push item
    else
      if current.length > 0
        numbers.push({
          item: current.join('').to_i,
          startX: idx - current.length,
          endX: idx - 1,
          y: idy
        })
        current = []
      end
    end
  end
end

result = 0
numbers.each do |number|
  is_done = false
  endItem = [number[:endX] + 1, maxX - 1].min
  startItem = [number[:startX] - 1, 0].max

  if checkItem(board[number[:y]][startItem])
    is_done = true
    result += number[:item]
  end

  if checkItem(board[number[:y]][endItem])
    is_done = true
    result += number[:item]
  end

  if !is_done && number[:y] > minY
    (startItem..endItem).each do |it|
      if !is_done && checkItem(board[number[:y] - 1][it])
        is_done = true
        result += number[:item]
      end
    end
  end

  if !is_done && number[:y] < maxY
    (startItem..endItem).each do |it|
      if !is_done && checkItem(board[number[:y] + 1][it])
        is_done = true
        result += number[:item]
      end
    end
  end

  if !is_done
    p "Number #{number[:item]} is not a part"
  end
end

p result
