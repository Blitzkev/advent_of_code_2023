games = IO.readlines("2.txt")

def process_cube_string(cube_string)
  cube_strings = cube_string.split(", ")
  cubes = {}
  cube_strings.each do |cube|
    cn, color = cube.split(" ")
    cubes[color] = cn.to_i
  end
  return cubes
end

#Process games into bag grabs
game_results = {}
# RESULTS = Game_number => [MAX_RED, MAX_GREEN, MAX_BLUE]
games.each do |game|
  game_name, cube_grab_string = game.split(": ")
  game_number = game_name.split(" ").last.to_i
  cube_grabs = cube_grab_string.split("; ")

  max_colors = {
    "red" => 0,
    "blue" => 0,
    "green" => 0
  }
  cube_grabs.each do |cube_grab|
    cubes = process_cube_string(cube_grab)
    max_colors.keys.each do |color|
      if cubes.has_key?(color)
        if cubes[color] > max_colors[color]
          max_colors[color] = cubes[color]
        end
      end
    end
  end

  game_results[game_number] = max_colors
end

#puts game_results
game_number_multiplied = []

game_results.each do |game_number, cube_counts|
    power = cube_counts["blue"] * cube_counts["green"] * cube_counts["red"]
    game_number_multiplied << power
end

puts game_number_multiplied.sum
