
instructions = []
items = {}
currents = []

def check_path(path, insts, items)
  total = 0
  idx = 0
  current = path.clone

  while !current.end_with?('Z')
    inst = insts[idx]
    current = items[current][inst]

    total += 1
    idx = (idx + 1) % insts.length
  end

  total
end

File.open('input.txt').each_with_index do |line, idx|
  if idx == 0
    instructions = line.delete("\n").split('')
  elsif line.delete("\n").length > 0
    data = line.delete("\n").scan(/(\w{3}) = \((\w{3}), (\w{3})\)/).flatten

    items[data[0]] = {
      'L' => data[1],
      'R' => data[2]
    }

    currents.push(data[0]) if data[0].end_with?('A') 
  end
end

p items.select { |key, value| key.end_with?('A') }
  .map { |item, val| check_path(item, instructions, items) }
  .inject(1) { |acc, item| acc.lcm(item) }
