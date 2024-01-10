result = 0

File.open('input.txt').each do |line|
  data = line.split(':').last.split(' | ').map { |item| item.split(' ').map(&:to_i) }
  power = data.last.inject(0) do |acc, item|
    data.first.include?(item) ? acc + 1 : acc
  end
  if power > 0
    result += (2 ** (power - 1))
  end
end

p result
