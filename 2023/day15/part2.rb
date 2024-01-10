boxes = {}

items = File.readlines('./input.txt', chomp: true).first.split(',')

def hash(item)
  item.bytes.inject(0) do |acc, it|
    ((acc + it) * 17) % 256
  end
end

items.each do |item|
  data = item.split(/[=-]/)
  box = hash(data.first)

  if data.length == 1 && boxes.key?(box)
    boxes[box] = boxes[box].select { |h| h[:label] != data.first }
  elsif data.length == 2
    if boxes.key?(box)
      index = boxes[box].find_index { |h| h[:label] == data.first}

      if index != nil
        boxes[box][index][:focal] = data.last.to_i
      else
        boxes[box].push({
          label: data.first,
          focal: data.last.to_i
        })
      end
    else
      boxes[box] = [{
        label: data.first,
        focal: data.last.to_i
      }]
    end
  end
end

res = boxes.inject(0) do |acc, (idx, box)|
  acc + box.each_with_index.inject(0) do |tot, (hsh, slot)|
    tot + (idx + 1) * (slot + 1) * hsh[:focal]
  end
end

pp res
