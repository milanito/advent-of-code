digits = %w[one two three four five six seven eight nine]
total = File.open('input.txt').inject(0) do |tot, line|
  tot + line.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|\d))/).flatten
    .values_at(0, -1)
    .map { |item| digits.index(item) != nil ? digits.index(item) + 1 : item }
    .join('').to_i
end
print total
