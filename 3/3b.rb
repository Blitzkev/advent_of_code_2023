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

gears = []
schematic.each_with_index do |line,y|
  puts "Processing line #{y}: #{line}"
  current_part_num = []
  current_pos = []
  line.each_with_index do |c, x|
    #puts "Processing character #{x}: #{c}"

    if c == "*"
      gears << [x,y]
    end

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
puts gears.inspect

valid_part_numbers = []

def check_positions_for_part_numbers(positions, part_numbers)
  # puts ""
  # puts positions.inspect
  touching_part_numbers = []
  positions.each do |pos|
    x = pos.first
    y = pos.last
    # puts "[x,y] = [#{x},#{y}]"
    # puts NON_SYM.inspect
    # puts SCHEM.inspect
    if NUMS.include?( SCHEM[y][x] )
      puts "found piece of a part_number at [#{x},#{y}]"
      # find the part_number this single piece belongs to
      part_numbers.each do |start_pos, pn|
        pn_y = start_pos.last
        start_x = start_pos.first
        end_x = (start_pos.first + pn.digits.count) - 1
        puts "part_number #{pn} ranges y = #{pn_y} and x = [#{start_x},#{end_x}]"
        if pn_y == y && (start_x <= x && end_x >= x)
          puts "adding pn #{pn} to valid numbers"
          touching_part_numbers << [start_pos,pn]
          break
        end
      end
    end
  end
  return touching_part_numbers
end


def check_left(position, height, part_numbers)
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

  return check_positions_for_part_numbers(positions_to_check, part_numbers)
end

def check_middle(position, height, part_numbers)
  x = position.first
  y = position.last
  positions_to_check = [[x,y-1], [x, y+1]]

  if y == 0
    positions_to_check = [positions_to_check.last]
  elsif y == height-1
    positions_to_check = [positions_to_check.first]
  end

  #puts positions_to_check.inspect
  return check_positions_for_part_numbers(positions_to_check, part_numbers)
end

def check_right(position, height, width, part_numbers)
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

  return check_positions_for_part_numbers(positions_to_check, part_numbers)
end


valid_part_numbers = []
gears.each do |gear|
  #find all part_numbers this gear is touching
  pn_left = check_left(gear, height, part_numbers)
  pn_right = check_right(gear, height, width, part_numbers)
  pn_mid = check_middle(gear, height, part_numbers)

  touching_parts = (pn_left + pn_right + pn_mid).uniq
  if touching_parts.count == 2
    puts touching_parts
    valid_part_numbers << (touching_parts.first.last * touching_parts.last.last)
  end
end
puts valid_part_numbers.sum

















