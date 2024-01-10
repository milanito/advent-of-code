cards = %w{A K Q J T 9 8 7 6 5 4 3 2}

def check_type(hand)
  return 0 if hand.uniq.length == 1

  tal = hand.tally

  return 1 if tal.values.max == 4
  return 2 if tal.values.sort == [2, 3]
  return 3 if tal.values.max == 3
  return 4 if tal.values.sort == [1, 2, 2]
  return 5 if tal.values.max == 2
  return 6
end

data = File.open('input.txt').map do |line|
  item = line.split(' ')
  hand = item.first.split('')
  {
    hand: hand,
    type: check_type(hand),
    indexes: hand.map { |it| cards.index(it) },
    bid: item.last.to_i
  }
end

pp data.sort_by { |hsh| [hsh[:type], hsh[:indexes][0], hsh[:indexes][1], hsh[:indexes][2], hsh[:indexes][3], hsh[:indexes][4]] }
  .reverse
  .each_with_index
  .map { |it, idx| it[:bid] * (idx + 1)}
  .sum
