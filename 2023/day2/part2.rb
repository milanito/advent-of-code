result = 0

File.open('input.txt').each do |line|
  data = line.split(':')
  hash = { red: 1, green: 1, blue: 1 }

  data.last().split(';').each do |game|
    game.split(', ').each do |item|
      total = item.split(' ').first().strip().to_i
      color = item.split(' ').last().strip().to_sym

      if hash[color] < total
        hash[color] = total
      end
    end
  end
  p hash

  result += hash.inject(1) { |acc, (key, value)| acc * value }
end

p result
