data = []

File.open('input.txt').each do |line|
  clean_line = line.gsub("\n", ' ').squeeze(' ')
  if clean_line.include? 'Time'
    data = clean_line.split(': ').last.strip.split(' ').map(&:to_i).map { |time| { time: time } }
  else
    clean_line.split(': ').last.strip.split(' ').map(&:to_i).each_with_index { |distance, idx| data[idx][:distance] = distance }
  end
end

result = data.map do |item|
  ((item[:time] + Math.sqrt(item[:time] ** 2 - 4 * item[:distance])) / 2).floor - ((item[:time] - Math.sqrt(item[:time] ** 2 - 4 * item[:distance])) / 2).floor
end
  .inject(1, &:*)

p result
