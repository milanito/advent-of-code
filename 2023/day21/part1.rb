def check_possibles(it, board)
  [
    { x: it[:x] + 1, y: it[:y] },
    { x: it[:x] - 1, y: it[:y] },
    { x: it[:x], y: it[:y] - 1 },
    { x: it[:x], y: it[:y] + 1 }
  ].select do |item|
    item[:x] > -1 && item[:x] < board[0].length && item[:y] > -1 && item[:y] < board.length && board[item[:y]][item[:x]] == '.'
  end
end

start = {}
done = {}

items = File.readlines('./input.txt', chomp: true).map.with_index do |line, id_row|
  data = line.split('')

  data.each_with_index { |it, id_col| start = { x: id_col, y: id_row } if it == 'S' }
  data
end

currents = [start]

step = 1

while step < 65
  currents.each { |it| it[:children] = check_possibles(it, items) } 
  
  currents = currents.map { |it| it[:children] }.flatten.uniq{ |item| "#{item[:x]}-#{item[:y]}" }

  currents.each do |item|
    done["#{item[:x]}-#{item[:y]}"] = true
  end
  

  step += 1
end

pp currents.uniq{ |item| "#{item[:x]}-#{item[:y]}" }.length + 1

currents.each do |item|
  items[item[:y]][item[:x]] = 'O'
end
