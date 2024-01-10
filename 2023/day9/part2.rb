def handle_line(line)
  items = line.delete("\n").split(' ').map(&:to_i)
  diffs = [items.clone]

  current = diffs[0]

  while current.last - current[-2] != 0
    diff = current.to_a[1..-1].map.with_index { |it, idx| it - current[idx] }
    diffs.push(diff)
    current = diff
  end
  diffs.push(current.to_a[1..-1].map.with_index { |it, idx| it - current[idx] })

  diffs = diffs.reverse

  diffs[0...-1].each.with_index.inject([0]) do |acc, (it, idx)|
    [diffs[idx + 1].first - acc.first] + acc
  end
  .first
end

res = 0
File.open('input.txt').each do |line|
  res += handle_line(line)
end
pp res

