result = {}
lines = File.open('input.txt').map do |line, idx|
  line.split(':').last.split(' | ').map { |item| item.split(' ').map(&:to_i) }
end

lines.each_with_index do |_, idx|
  result[idx] = 1
end

lines.each_with_index do |data, idx|
  power = data.last.inject(0) do |acc, item|
    data.first.include?(item) ? acc + 1 : acc
  end

  if power > 0
    (1..power).each do |it|
      if result.key?(idx + it)
        result[idx + it] += result[idx]
      else
        result[idx + it] = result[idx] 
      end
    end
  end
end

p result.values.inject(&:+)
