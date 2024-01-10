lines = File.readlines('./input.txt', chomp: true)

min = 200000000000000
max = 400000000000000

def random_string
  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  string = (0...15).map { o[rand(o.length)] }.join
end

def should_continue(items)
  items.inject(false) { |acc, item| acc || (item[:inside] || (!item[:inside] && !item[:has_been_inside])) }
end

couples = []

data = lines.map do |line|
  data = line.split(' @ ')

  position = data.first.split(', ').map(&:to_i)
  velocity = data.last.split(', ').map(&:to_i)

  slope = velocity[1] / velocity[0].to_f
  calc = position[1] - slope * position[0]


  item = {
    name: random_string(),
    x: position[0],
    y: position[1],
    z: position[2],
    vx: velocity[0],
    vy: velocity[1],
    vz: velocity[2],
    slope: slope,
    calc: calc
  }

  item
end

data.each_with_index do |item, idx|
  data.reject.with_index { |el, index| index == idx || el[:slope] == item[:slope] }.each do |other|
    x = (other[:calc] - item[:calc]) / (item[:slope] - other[:slope])

    next if x > max || x < min || (item[:vx] < 0 && x > item[:x]) || (item[:vx] > 0 && x < item[:x]) || (other[:vx] < 0 && x > other[:x]) || (other[:vx] > 0 && x < other[:x])

    y = item[:slope] * x + item[:calc]

    next if y > max || y < min || (item[:vy] < 0 && y > item[:y]) || (item[:vy] > 0 && y < item[:y]) || (other[:vy] < 0 && y > other[:y]) || (other[:vy] > 0 && y < other[:y])

    couples.push([item[:name], other[:name]].sort)
  end
end

pp couples.uniq.length
