galaxies = []
final_galaxies = []
idx_line = 0
total_columns = 0
factor = 999999

class Galaxy < Data.define(:x, :y)
  def distance(galaxy)
    (galaxy.y - y).abs + (galaxy.x - x).abs
  end
end

File.open('input.txt').each do |line|
  line_arr = line.delete("\n").split('')

  if total_columns == 0
    total_columns = line_arr.length
  end

  has_galaxy = false

  line_arr.each_with_index do |it, idx_it|
    if it == '#'
      has_galaxy = true
      galaxies.push(Galaxy.new(idx_it, idx_line))
    end
  end
  if has_galaxy == false
    idx_line += factor
  end

  idx_line += 1
end

columns_without = (0...total_columns).to_a - galaxies.map(&:x).uniq

galaxies.each do |galaxy|
  final_galaxies.push(Galaxy.new(galaxy.x + columns_without.select { |idx| idx < galaxy.x }.length * factor, galaxy.y))
end

res = 0

final_galaxies.each_with_index do |galaxy, idx|
  final_galaxies.last(final_galaxies.length - (idx + 1)).each_with_index do |second, id|
    distance = galaxy.distance(second)
    # pp "Between galaxy #{idx + 1} and galaxy #{id + 1}: #{distance}"
    res += distance
  end
end

pp res

