data = {}

File.open('input.txt').each do |line|
  clean_line = line.gsub("\n", ' ').squeeze(' ')
  if clean_line.include? 'Time'
    data[:time] = clean_line.split(': ').last.strip.split(' ').join('').to_i
  else
    data[:distance] = clean_line.split(': ').last.strip.split(' ').join('').to_i
  end
end

res = ((data[:time] + Math.sqrt(data[:time] ** 2 - 4 * data[:distance])) / 2).floor - ((data[:time] - Math.sqrt(data[:time] ** 2 - 4 * data[:distance])) / 2).floor

p res
