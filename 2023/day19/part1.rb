items = File.readlines('./input.txt', chomp: true)

total = 0
parts = []
rules = {}

is_rules = true

def create_rules(definition)
  definition.split(',').map do |defi|
    split_defi = defi.scan(/([a-z])(<|>)(\d*):([a-zA-Z]*)/).first

    if split_defi == nil
      {
        type: 'direct',
        dest: defi
      }
    else
      {
        type: 'test',
        key: split_defi[0],
        comparator: split_defi[1],
        value: split_defi[2].to_i,
        dest: split_defi[3]
      }
    end
  end
end

def get_part_total(part)
  part[:x] + part[:m] + part[:a] + part[:s]
end

items.each do |line|
  if line == ''
    is_rules = false 
    next
  end

  if is_rules
    data = line.scan(/([a-z]*){(.*)}/).first

    rules[data.first] = create_rules(data.last)
  else
    data = line.scan(/{x=(\d*),m=(\d*),a=(\d*),s=(\d*)}/).first
    parts.push({
      x: data[0].to_i, m: data[1].to_i, a: data[2].to_i, s: data[3].to_i
    })
  end
end

parts.each do |part|
  current = 'in'

  while current != 'A' && current != 'R'
    rules[current].each do |rule|
      if rule[:type] == 'direct' ||
        (
          (rule[:comparator] == '>' && part[rule[:key].to_sym] > rule[:value]) ||
              rule[:comparator] == '<' && part[rule[:key].to_sym] < rule[:value]
        )
        current = rule[:dest]
        break
      end
    end
  end

  total += get_part_total(part) if current == 'A'
end

pp total
