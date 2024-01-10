lines = File.readlines('./input.txt', chomp: true)

def generate_string
  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  string = (0...12).map { o[rand(o.length)] }.join
end

def is_point(start, en)
  return start[:x] - en[:x] == 0 && start[:y] - en[:y] == 0
end

def distance(start, en)
  Math.sqrt((start[:x] - en[:x]) ** 2 + (start[:y] - en[:y]) ** 2)
end

def intersect(start1, end1, start2, end2, check_height)
  if check_height
    return false if [start2[:z], end2[:z]].min > [start1[:z], end1[:z]].max + 1
  end

  if is_point(start1, end1)
    if is_point(start2, end2)
      return start1[:x] == start2[:x] && start1[:y] == start2[:y]
    end

    return distance(start1, start2) + distance(start1, end2) == distance(start2, end2)
  else
    if is_point(start2, end2)
      return distance(start1, start2) + distance(end1, start2) == distance(start1, end1)
    end
  end

  det = (end1[:x] - start1[:x]) * (end2[:y] - start2[:y]) - (end2[:x]- start2[:x]) * (end1[:y] - start1[:y]);

  return false if det == 0

  lambda = ((end2[:y] - start2[:y]) * (end2[:x] - start1[:x]) + (start2[:x]- end2[:x]) * (end2[:y] - start1[:y])) / det
  gamma = ((start1[:y] - end1[:y]) * (end2[:x] - start1[:x]) + (end1[:x] - start1[:x]) * (end2[:y] - start1[:y])) / det

  return (0 <= lambda && lambda <= 1) && (0 <= gamma && gamma <= 1)
end

bricks = []

lines.each do |line|
  data = line.split('~')

  bricks.push({
    name: generate_string(),
    start: {
      x: data.first.split(',').first.to_i,
      y: data.first.split(',')[1].to_i,
      z: data.first.split(',').last.to_i,
    },
    end: {
      x: data.last.split(',').first.to_i,
      y: data.last.split(',')[1].to_i,
      z: data.last.split(',').last.to_i,
    },
    supports: []
  })
end

fallen = []

bricks.sort_by { |h| [h[:start][:z], h[:end][:z]].min }.each do |brick|
  to_check = fallen.select { |fall| intersect(fall[:start], fall[:end], brick[:start], brick[:end], false) }

  while [brick[:start][:z], brick[:end][:z]].min > 1
    is_falling = true

    to_check.each do |fall|
      if intersect(fall[:start], fall[:end], brick[:start], brick[:end], true)
        is_falling = false
        fall[:supports].push(brick[:name])
      end
    end

    if !is_falling
      break
    end

    brick[:start][:z] -= 1
    brick[:end][:z] -= 1
  end

  fallen.push(brick.clone)
end

res = fallen.inject({ ok: 0 }) do |acc, fall|
  if fall[:supports].length == 0
    acc[:ok] += 1
  else
    key = fall[:supports].join('-')
    if !acc.key?(key)
      acc[key] = 1
    else
      acc[key] += 1
    end
  end

  acc
end
  .inject(0) do |acc, (k, value)|
    if (value > 1) || k.to_s == 'ok'
      acc += value 
    end

    acc
  end

pp res
