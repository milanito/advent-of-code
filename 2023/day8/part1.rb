instructions = []
items = {}
File.open('input.txt').each_with_index do |line, idx|
  if idx == 0
    instructions = line.delete("\n").split('')
  elsif line.delete("\n").length > 0
    data = line.delete("\n").scan(/(\w{3}) = \((\w{3}), (\w{3})\)/).flatten

    items[data[0]] = {
      'L' => data[1],
      'R' => data[2]
    }
  end
end

current = 'AAA'
total = 0
idx = 0

while current != 'ZZZ'
  instruction = instructions[idx]

  current = items[current][instruction]
  total += 1
idx = (idx + 1) % instructions.length
end

p total
