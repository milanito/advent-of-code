lines = File.readlines('./input.txt', chomp: true)

data = lines.map { |line| line.split('') }

res = data.each_with_index.inject(data.clone) do |acc, (line, idx)|
  if idx > 0
    line.each_with_index do |item, idx_item|
      line_idx = idx

      if acc[line_idx][idx_item] == 'O' 
        while line_idx > 0 && acc[line_idx - 1][idx_item] == '.'
            acc[line_idx][idx_item] = '.'
            acc[line_idx - 1][idx_item] = 'O'
          line_idx -= 1
        end
      end
    end
  end

  acc
end

result = res.reverse.each_with_index.inject(0) do |acc, (line, idx)|
  acc + line.select { |it| it == 'O' }.length * (idx + 1)
end

pp result
