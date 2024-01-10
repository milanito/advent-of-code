class Range
  def intersection(other)
    raise ArgumentError, 'value must be a Range' unless other.kind_of?(Range)

    my_min, my_max = first, exclude_end? ? max : last
    other_min, other_max = other.first, other.exclude_end? ? other.max : other.last

    new_min = self === other_min ? other_min : other === my_min ? my_min : nil
    new_max = self === other_max ? other_max : other === my_max ? my_max : nil

    new_min && new_max ? new_min..new_max : nil
  end

  alias_method :&, :intersection
end

seeds = []

File.open('input.txt').map { |it| it.delete("\n") }.each do |line|
  if line.include?('seeds') 
    seeds = line.split(': ').last().split(' ').map(&:to_i)
      .each_slice(2)
      .map { |items| { item: (items[0]...(items[0] + items[1])), is_done: false }}
  elsif line.include?('map')
    seeds = seeds.map { |it| { item: it[:item], is_done: false }}
  elsif line.length > 0
    data = line.split(' ').map(&:to_i)
    range_source = (data[1]...(data[1] + data[2]))
    range_destination = (data[0]...(data[0] + data[2]))

    seeds = seeds.inject([]) do |acc, seed|
      range_intersection = seed[:item].intersection(range_source)

      if seed[:is_done] || range_intersection == nil
        acc.push seed
      elsif range_source.cover? seed[:item]
        acc.push({
          item: ((data[0] + (seed[:item].first - range_source.first))...(data[0] + data[2] - (range_source.last - seed[:item].last))),
          is_done: true
        })
      elsif seed[:item].cover? range_source
        acc.push({
          item: (seed[:item].first...range_source.first),
          is_done: false 
        })
        acc.push({
          item: ((range_source.last + 1)...seed[:item].last),
          is_done: false 
        })
        acc.push({
          item: range_destination,
          is_done: true
        })
      elsif seed[:item].first < range_source.first
        acc.push({
          item: (seed[:item].first...range_source.first),
          is_done: false 
        })
        acc.push({
          item: (data[0]...(data[0] + (range_source.last - seed[:item].last))),
          is_done: true
        })
      else
        acc.push({
          item: ((data[0] + seed[:item].first - range_source.first)...(data[0] + data[2])),
          is_done: true
        })
        acc.push({
          item: (range_source.last...seed[:item].last),
          is_done: false
        })
      end

      acc
    end
  end
end

p seeds.map { |seed| seed[:item].first }.min

