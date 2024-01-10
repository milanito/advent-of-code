lines = File.readlines('./input.txt', chomp: true)

@cache = {}

def check_line(line, groups)
  res = 0

  if @cache["#{line.join('')}|#{groups.join('')}"] != nil
    return @cache["#{line.join('')}|#{groups.join('')}"]
  end

  index = line.find_index('?')

  if index == nil
    arr = line.join('').split('.').reject { |c| c.empty? }.map(&:length)

    res = arr == groups ? 1 : 0
  else
    one = line.clone
    two = line.clone
    one[index] = '.'
    two[index] = '#'

    res = check_line(one, groups) + check_line(two, groups)
  end

  @cache["#{line.join('')}|#{groups.join('')}"] = res

  return res
end

res = lines.inject(0) do |acc, line|
  data = line.split(' ')
  groups = data.last.split(',').map(&:to_i)
  items = data.first.split('')

  acc + check_line(items, groups)
end

pp res

