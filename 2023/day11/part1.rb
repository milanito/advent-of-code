board = []
galaxies = []
final_galaxies = []
idx_line = 0

class Galaxy < Data.define(:x, :y)
  def distance(galaxy)
  (galaxy.y - y).abs + (galaxy.x - x).abs
  end
end

File.open('input.txt').each do |line|
  current = []
  has_galaxy = false
  line.delete("\n").split('').each_with_index do |it, idx_it|
    current.push(it)
    if it == '#'
      has_galaxy = true
      galaxies.push(Galaxy.new(idx_it, idx_line))
    end
  end
  board.push(current)
  if has_galaxy == false
    idx_line += 1
    board.push(current.clone)
  end

  idx_line += 1
end

columns_without = (0...board[0].length).to_a - galaxies.map(&:x).uniq

galaxies.each do |galaxy|
  final_galaxies.push(Galaxy.new(galaxy.x + columns_without.select { |idx| idx < galaxy.x }.length, galaxy.y))
end

pp final_galaxies

res = 0

final_galaxies.each_with_index do |galaxy, idx|
  final_galaxies.each_with_index do |second, id|
    distance = galaxy.distance(second)
    pp "Between galaxy #{idx + 1} and galaxy #{id + 1}: #{distance}"
    res += distance
  end
end

pp res / 2
