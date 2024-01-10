require 'matrix'
@factor = 1

def diff(arr1, arr2)
  arr1.zip(arr2)
    .count {|a, b| a != b}
end

def check_lines_reflection(mat)
  (0...(mat.row_count() - 1)).each do |idx|
    total_diff = 0
    is_ok = true

    i = idx
    j = idx + 1

    while i > -1 && j < mat.row_count
      total_diff += diff(mat.row(i).to_a, mat.row(j).to_a)
      if total_diff > @factor
        is_ok = false
        break
      end
      i -= 1
      j += 1
    end
 
    return idx + 1 if is_ok && total_diff == @factor
  end

  return 0
end

def check_columns_reflection(mat)
  (0...(mat.column_count() - 1)).each do |idx|
    total_diff = 0
    is_ok = true

    i = idx
    j = idx + 1

    while i > -1 && j < mat.column_count
      total_diff += diff(mat.column(i).to_a, mat.column(j).to_a) 
      if total_diff > @factor
        is_ok = false
        break
      end
      i -= 1
      j += 1
    end
 
    return idx + 1 if is_ok && total_diff == @factor
  end

  return 0
end

lines = File.readlines('./input.txt', chomp: true)

data = lines.chunk { |line| line == '' }.to_a.filter { |it| !it.first }
  .map { |arr| arr.last.map { |it| it.split('') } } 
  .map { |it| Matrix[*it] }

res = data.inject(0) do |acc, mat|
  lines_reflection = check_lines_reflection(mat)

  if lines_reflection > 0
    acc + 100 * lines_reflection
  else
    columns_reflection = check_columns_reflection(mat)
    acc + columns_reflection
  end
end

pp res
