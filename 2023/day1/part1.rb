data = File.open('input.txt').inject(0) { |tot, line| tot + line.scan(/\d/).values_at(0, -1).join('').to_i

print data
