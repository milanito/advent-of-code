cards = %w{A K Q T 9 8 7 6 5 4 3 2 J}

def check_type(hand)
  return 0 if hand.uniq.length == 1

  tal = hand.tally

  if tal.values.max == 4
    return 0 if tal["J"] == 1 || tal["J"] == 4
    return 1
  end

  if tal.values.sort == [2, 3]
    return 0 if tal["J"] == 2 || tal["J"] == 3
    return 2 
  end

  if tal.values.max == 3
    return 1 if tal["J"] == 1 || tal["J"] == 3
    return 3 
  end

  if tal.values.sort == [1, 2, 2]
    return 1 if tal["J"] == 2
    return 2 if tal["J"] == 1

    return 4 
  end

  if tal.values.max == 2
    return 3 if tal["J"] == 1 || tal["J"] == 2
    return 5
  end

  return 5 if tal["J"] == 1

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

