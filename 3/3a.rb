schematic = IO.readlines("3.txt")
#schematic = IO.readlines("3small.txt")
SCHEM = schematic.map!{|s| s.chomp.chars}.freeze

width = schematic.first.length
height = schematic.length

#find part numbers
part_numbers = {} #start_position(x,y) => part number

NUMS = ("0".."9").freeze
DOT = ".".freeze
NON_SYM = (NUMS.to_a + DOT.chars).freeze
schematic.each_with_index do |line,y|
  puts "Processing line #{y}: #{line}"
  current_part_num = []
  current_pos = []
  line.each_with_index do |c, x|
    #puts "Processing character #{x}: #{c}"
    if NUMS.include?(c)
      puts "found number #{c}"
      current_part_num << c
      if current_pos.empty?
        current_pos = [x,y]
      end

      if x == (width -1)
        puts "part number end found.\nPart number #{current_part_num.join.to_i} at #{current_pos}"
        part_numbers[current_pos] = current_part_num.join.to_i
      end

    else
      if current_part_num != []
        puts "part number end found.\nPart number #{current_part_num.join.to_i} at #{current_pos}"
        part_numbers[current_pos] = current_part_num.join.to_i
        current_part_num = []
        current_pos = []
      end
    end
  end
end

puts part_numbers.inspect

valid_part_numbers = []

def check_positions_for_special_character(positions)
  # puts ""
  # puts positions.inspect
  positions.each do |pos|
    x = pos.first
    y = pos.last
    # puts "[x,y] = [#{x},#{y}]"
    # puts NON_SYM.inspect
    # puts SCHEM.inspect
    if !NON_SYM.include?( SCHEM[y][x] )
      puts "found special char at [#{x},#{y}]"
      return true
    end
  end
  return false
end


def check_left(position, height)
  x = position.first
  y = position.last
  if x == 0
    return false
  end

  positions_to_check = [[x-1,y-1], [x-1,y], [x-1, y+1]]

  if y == 0
    positions_to_check = positions_to_check[1..-1]
  elsif y == height-1
    positions_to_check = positions_to_check[0..-2]
  end

  return check_positions_for_special_character(positions_to_check)
end

def check_middle(position, height)
  x = position.first
  y = position.last
  positions_to_check = [[x,y-1], [x, y+1]]

  if y == 0
    positions_to_check = [positions_to_check.last]
  elsif y == height-1
    positions_to_check = [positions_to_check.first]
  end

  #puts positions_to_check.inspect
  return check_positions_for_special_character(positions_to_check)
end

def check_right(position, height, width)
  x = position.first
  y = position.last
  if x == width - 1
    return false
  end

  positions_to_check = [[x+1,y-1], [x+1,y], [x+1, y+1]]

  if y == 0
    positions_to_check = positions_to_check[1..-1]
  elsif y == height-1
    positions_to_check = positions_to_check[0..-2]
  end

  return check_positions_for_special_character(positions_to_check)
end



part_numbers.each do |start_pos, part_number|
  pn_length = (part_number.digits.count - 1)
  start_x = start_pos.first
  end_x = start_x + pn_length
  valid = false
  #puts "checking pn: #{part_number} at start_pos [#{start_pos.first},#{start_pos.last}]"
  (start_x..end_x).each do |x|
    #check left
    if x == start_x
      cv = check_left([x, start_pos.last], height)
      if cv
        valid = true
        break
      end
    end
    #check right
    if x == end_x
      cv = check_right([x, start_pos.last], height, width)
      if cv
        valid = true
        break
      end
    end
    #check middle on all
    cv = check_middle([x, start_pos.last], height)
    if cv
      valid = true
      break
    end
  end

  if valid
    valid_part_numbers << part_number
    puts "adding part_number #{part_number} with start_pos #{start_pos}"
  end
end

puts valid_part_numbers.sum















