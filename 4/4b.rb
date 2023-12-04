scratchcards = IO.readlines("4.txt")
#scratchcards = IO.readlines("4small.txt")

points = 0
processed_cards = {}
scratchcards.each do |scratchcard|
  card_title, card_numbers = scratchcard.split(": ")
  card_num = card_title.split(" ").last.to_i
  winning_num_string, my_num_string = card_numbers.split(" | ")

  winning_num_set = winning_num_string.split(" ").to_set
  my_num_set = my_num_string.split(" ").to_set
  processed_cards[card_num] = [winning_num_set, my_num_set]
end

def process_card(numbers)
  winning_num_set, my_num_set = numbers
  overlap = winning_num_set.intersection( my_num_set )
  return overlap.length
end

puts processed_cards
card_stack = processed_cards.keys
points = card_stack.count


while !card_stack.empty?
  card_number = card_stack.pop
  card = processed_cards[card_number]
  winning_cards_to_add = process_card(card)
  if winning_cards_to_add > 0
    s = card_number + 1
    e = card_number + winning_cards_to_add
    (s..e).each do |cn|
      card_stack.push(cn)
      points += 1
    end
  end
end

puts points
