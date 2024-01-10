hash = { red: 12, green: 13, blue: 14 }

result = 0
File.open('input.txt').each do |line|
  data = line.split(':')
  id = data.first().split(' ').last.to_i

  is_ok = true

  data.last().split(';').each do |game|
    if !is_ok
      break
    end
    game.split(', ').each do |item|
      total = item.split(' ').first().strip().to_i
      color = item.split(' ').last().strip().to_sym

      if hash[color] < total
        is_ok = false
        break
      end
    end
  end

  if is_ok
    p "Game #{id} is OK"
    result += id
  end
end

p result
