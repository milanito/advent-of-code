seeds = []

File.open('input_test.txt').map { |it| it.delete("\n") }.each do |line|
  if line.include?('seeds') 
    seeds = line.split(': ').last().split(' ').map { |it| { item: it.to_i, is_done: false }}
  elsif line.include?('map')
    seeds = seeds.map { |it| { item: it[:item], is_done: false }}
  elsif line.length > 0
    seeds = seeds.map do |seed|
      if seed[:is_done]
        next seed
      end

      data = line.split(' ').map(&:to_i)

      if seed[:item] >= data[1] && seed[:item] <= (data[1] + data[2] - 1)
        next {
          item: data[0] + (seed[:item] - data[1]),
          is_done: true
        }
      end

      next seed
    end
  end
end

p seeds.map { |seed| seed[:item] }.min
