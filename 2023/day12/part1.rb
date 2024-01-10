lines = File.readlines('./input.txt', chomp: true)

def check_line(line, groups)
  index = line.find_index('?')

  if index == nil
    res = line.join('').split('.').reject { |c| c.empty? }.map(&:length)

    return res == groups ? 1 : 0
  end

  one = line.clone
  two = line.clone
  one[index] = '.'
  two[index] = '#'

  return check_line(one, groups) + check_line(two, groups)
end

res = lines.inject(0) do |acc, line|
  data = line.split(' ')
  groups = data.last.split(',').map(&:to_i)
  items = data.first.split('')

  acc + check_line(items, groups)
end

pp res
