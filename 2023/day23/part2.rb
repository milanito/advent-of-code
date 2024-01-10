def run(file_name)
  file_name = File.basename(file_name, File.extname(file_name))
  puts "solving \"#{file_name}\""
  input = File.read("../inputs/" + file_name[0..-2] + "_input.txt").strip
  result = nil
  time = Benchmark.realtime do
    result = solve(input)
  end
  puts "result"
  puts result.inspect
  puts "time taken: #{to_human_duration(time)}"
end

MAZE_CHARS = {'#' => 5, '.' => 4, '^' => 0, '<' => 1, 'v' => 2, '>' => 3} unless defined? MAZE_CHARS
REVERSE_MAZE_CHARS = MAZE_CHARS.invert unless defined? REVERSE_MAZE_CHARS
DIRECTIONS_ARR = [:north, :west, :south, :east] unless defined? DIRECTIONS_ARR

def solve(arg)
  maze = parse_input(arg)
  # puts "maze:"
  # maze.each do |row|
  #   puts row.map { |n| REVERSE_MAZE_CHARS[n] }.join
  # end
  max_y = maze.size - 1

  graph, start_distance, end_distance = calc_graph(maze, max_y)

  # puts "maze:"
  # maze.each_with_index do |row, y|
  #   puts row.map.with_index { |n, x| nodes[[x, y]] || REVERSE_MAZE_CHARS[n] }.join
  # end
  # puts "graph: #{graph}"

  calc_longest_path(graph) * -1 + start_distance + end_distance
end

def calc_longest_path(graph)
  paths = []
  queue = [[0, 0]]
  while !queue.empty?
    node, steps = queue.shift
    # puts "node: #{node}, steps: #{steps}"
    if node == 1
      paths << steps
      next
    end
    # puts "before: #{graph[node]}"
    graph[node].each do |new_node, additional_steps|
      queue << [new_node, steps + additional_steps]
    end
  end

  # puts "paths: #{paths.size}"
  paths.min
end

def calc_graph(maze, max_y)
  start_x, start_y, start_distance, start_direction = calc_start_path(maze)
  end_x, end_y, end_distance = calc_end_path(maze, max_y)

  new_id = 0
  nodes = {[start_x, start_y] => new_id}
  edges = Hash.new() { |hsh, k| hsh[k] = {} }

  queue = get_valid_next_locations(maze, start_x, start_y, 1, start_direction, new_id, true)
  nodes[[end_x, end_y]] = new_id += 1

  while !queue.empty?
    x, y, steps, direction, last_id, reversible = queue.pop
    dir_val = maze[y][x]
    # puts "(#{x}, #{y}) #{direction}: #{steps}, last_id: #{last_id}, reversible: #{reversible}, dir_val: #{dir_val}"
    next if dir_val != 4 && DIRECTIONS_ARR[dir_val] != direction
    reversible = false if reversible && dir_val <= 3
    id = nodes[[x, y]]
    if id
      # puts "crossroad (seen): (#{x}, #{y}): #{last_id} -> #{id}, direction: #{direction}, reversible: #{reversible}"
      edges[last_id][id] = -steps
      edges[id][last_id] = -steps if reversible
      next
    end

    locations = get_valid_next_locations(maze, x, y, steps + 1, direction, last_id, reversible)
    # puts "locations: #{locations}"
    if locations.size > 1
      nodes[[x, y]] = new_id += 1
      # puts "crossroad (new): (#{x}, #{y}): #{last_id} -> #{new_id}, direction: #{direction}, reversible: #{reversible}"

      edges[last_id][new_id] = -steps
      edges[new_id][last_id] = -steps if reversible
      locations.map! do |xx, yy, _, new_direction, _, _|
        [xx, yy, 1, new_direction, new_id, true]
      end
    end
    queue.concat(locations)
  end

  [edges, start_distance, end_distance]
end

def calc_start_path(maze)
  x = maze[0].index(4)
  y = 0
  steps = 0
  direction = :south

  loop do
    # puts "(#{x}, #{y}) #{direction}: #{steps}"
    locations = get_valid_next_locations(maze, x, y, steps + 1, direction, nil, false)
    if locations.size > 1
      return [x, y, steps, direction]
    end
    x, y, steps, direction = locations[0]
  end
end

def calc_end_path(maze, max_y)
  x = maze[max_y].index(4)
  y = max_y
  steps = 0
  direction = :north

  loop do
    # puts "(#{x}, #{y}) #{direction}: #{steps}"
    locations = get_valid_next_locations(maze, x, y, steps + 1, direction, nil, false)
    if locations.size > 1
      return [x, y, steps]
    end
    x, y, steps, direction = locations[0]
  end
end

def get_valid_next_locations(maze, x, y, new_steps, direction, last_id, reversible)
  get_next_locations(x, y, new_steps, direction, last_id, reversible).select do |xx, yy, _, _, _, _|
    maze[yy][xx] <= 4
  end
end

def get_next_locations(x, y, new_steps, direction, last_id, reversible)
  case direction
  when :north
    [[x, y - 1, new_steps, direction, last_id, reversible], [x - 1, y, new_steps, :west, last_id, reversible], [x + 1, y, new_steps, :east, last_id, reversible]]
  when :west
    [[x - 1, y, new_steps, direction, last_id, reversible], [x, y - 1, new_steps, :north, last_id, reversible], [x, y + 1, new_steps, :south, last_id, reversible]]
  when :south
    [[x, y + 1, new_steps, direction, last_id, reversible], [x - 1, y, new_steps, :west, last_id, reversible], [x + 1, y, new_steps, :east, last_id, reversible]]
  when :east
    [[x + 1, y, new_steps, direction, last_id, reversible], [x, y - 1, new_steps, :north, last_id, reversible], [x, y + 1, new_steps, :south, last_id, reversible]]
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    str.chars.map do |c|
      MAZE_CHARS[c]
    end
  end
end

run('./input.txt')
