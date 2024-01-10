def check_possibles(it, board)
  [
    { x: it[:x] + 1, y: it[:y] },
    { x: it[:x] - 1, y: it[:y] },
    { x: it[:x], y: it[:y] - 1 },
    { x: it[:x], y: it[:y] + 1 }
  ].select do |item|
      board[item[:y] % board.length][item[:x] % board[0].length] == '.' || board[item[:y] % board.length][item[:x] % board[0].length] == 'S' 
  end
end

start = {}

items = File.readlines('./input.txt', chomp: true).map.with_index do |line, id_row|
  data = line.split('')

  data.each_with_index { |it, id_col| start = { x: id_col, y: id_row } if it == 'S' }
  data
end

currents = [start]

step = 1

while step < 327
  currents = currents.map { |it| it[:children] = check_possibles(it, items) }
    .flatten.uniq{ |item| "#{item[:x]}-#{item[:y]}" }

  step += 1
end

pp currents.uniq{ |item| "#{item[:x]}-#{item[:y]}" }.length
