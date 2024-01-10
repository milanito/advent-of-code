items = File.readlines('./input.txt', chomp: true).first.split(',')

def hash(item)
  item.bytes.inject(0) do |acc, it|
    ((acc + it) * 17) % 256
  end
end

res = items.inject(0) { |acc, item| acc + hash(item) }

pp res
