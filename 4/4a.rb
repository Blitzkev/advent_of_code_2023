scratchcards = IO.readlines("4.txt")

points = 0
scratchcards.each do |scratchcard|
  card_title, card_numbers = scratchcard.split(": ")
  winning_num_string, my_num_string = card_numbers.split(" | ")

  winning_num_set = winning_num_string.split(" ").to_set
  my_num_set = my_num_string.split(" ").to_set

  overlap = winning_num_set.intersection( my_num_set )
  if overlap.empty?
    next
  else
    points += 2**(overlap.length-1)
  end
end

puts points
