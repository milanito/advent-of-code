require 'matrix'
cycles = 1000000000
results = []

lines = File.readlines('./input.txt', chomp: true)

data = Matrix[*lines.map { |line| line.split('') }]

def calculate_result(matr)
  row_count = matr.row_count

  result = (0...row_count).to_a.inject(0) do |acc, idx|
    acc + matr.row(idx).to_a.select { |it| it == 'O' }.length * (row_count - idx)
  end
end

def handle_north(mat)
  (0...mat.row_count).inject(mat.clone) do |acc, idx|
    if idx > 0
      mat.row(idx).to_a.each_with_index do |it, idx_item|
        line_idx = idx

        if acc[line_idx, idx_item] == 'O' 
          while line_idx > 0 && acc[line_idx - 1, idx_item] == '.'
            acc[line_idx, idx_item] = '.'
            acc[line_idx - 1, idx_item] = 'O'
            line_idx -= 1
          end
        end
      end
    end
    
    acc
  end
end

def handle_south(mat)
  mat_row_count = mat.row_count

  (1..mat_row_count).inject(mat.clone) do |acc, idx|
    if idx > 1
      mat.row(mat_row_count - idx).to_a.each_with_index do |it, idx_item|
        line_idx = mat_row_count - idx

        if acc[line_idx, idx_item] == 'O' 
          while line_idx < mat_row_count - 1 && acc[line_idx + 1, idx_item] == '.'
            acc[line_idx, idx_item] = '.'
            acc[line_idx + 1, idx_item] = 'O'
            line_idx += 1
          end
        end
      end
    end
    
    acc
  end
end

def handle_east(mat)
  mat_column_count = mat.column_count

  (1..mat_column_count).inject(mat.clone) do |acc, idx|
    if idx > 1
      mat.column(mat_column_count - idx).to_a.each_with_index do |it, idx_item|
        column_idx = mat_column_count - idx

        if acc[idx_item, column_idx] == 'O' 
          while column_idx < mat_column_count - 1 && acc[idx_item, column_idx + 1] == '.'
            acc[idx_item, column_idx] = '.'
            acc[idx_item, column_idx + 1] = 'O'
            column_idx += 1
          end
        end
      end
    end
    
    acc
  end
end

def handle_west(mat)
  (0...mat.column_count).inject(mat.clone) do |acc, idx|
    if idx > 0
      mat.column(idx).to_a.each_with_index do |it, idx_item|
        column_idx = idx

        if acc[idx_item, column_idx] == 'O' 
          while column_idx > 0 && acc[idx_item, column_idx - 1] == '.'
            acc[idx_item, column_idx] = '.'
            acc[idx_item, column_idx - 1] = 'O'
            column_idx -= 1
          end
        end
      end
    end
    
    acc
  end
end

cycle = 0
save = data.clone

(0...cycles).each do |idx|
  data = handle_north(data)
  data = handle_west(data)
  data = handle_south(data)
  data = handle_east(data)

  str = data.to_s

  if results.map{ |it| it[:str] }.include?(str)
    cycle = results.map{ |it| it[:str] }.find_index(str)
    break
  else
    results.push({
      str: str,
      calcul: calculate_result(data)
    })
  end
end

res = (cycles - cycle) % results.drop(cycle).length - 1

pp results.drop(cycle)[res][:calcul]
