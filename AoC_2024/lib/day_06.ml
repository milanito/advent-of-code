open Base

type direction = UP | DOWN | LEFT | RIGHT
type position = (int * int)
type guard = {dir: direction; pos: position}
type map = char array array
type data = {board: map; peon: guard; played: position list}

type input = Input of data
type answer = Answer of int | Unknown

let print_position (pos: position) =
  let (x, y) = pos in
  let _ = Stdio.Out_channel.output_string Stdio.stdout "Position -> " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string x) in
  let _ = Stdio.Out_channel.output_string Stdio.stdout "," in
  let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string y) in
   Stdio.Out_channel.output_string Stdio.stdout "\n"

let print_played (poss: position list) = poss
  |> List.map ~f:print_position
    
let debug_str (str: string) =
  let _ = Stdio.Out_channel.output_string Stdio.stdout str in
   Stdio.Out_channel.output_string Stdio.stdout "\n"

let handle_line acc line : data =
  let brd = String.to_array line
  in
  if Array.exists brd ~f:(fun x -> Char.equal x '^')
    then
      let x = Array.foldi brd ~init:0 ~f:(fun idx acc el -> if Char.equal el '^' then idx else acc) in
      let updated_board = Array.map ~f:(fun it -> if Char.equal it '^' then '.' else it) brd in
      {board = (Array.append acc.board (Array.create ~len:1 updated_board)); peon = {dir = UP; pos = (x, Array.length acc.board)}; played = []}
    else
      {board = (Array.append acc.board (Array.create ~len:1 brd)); peon = acc.peon; played = []}

let text_to_input (txt: string): input =
  let new_input = {board = List.to_array []; peon = {dir = UP; pos = (0,0)}; played = []} in
  txt
    |> String.split_lines
    |> List.fold_left ~init:new_input ~f:(handle_line)
    |> fun x -> Input x

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let move_guard (current: data) : guard =
  let (x, y) = current.peon.pos in
  match current.peon.dir with
    UP -> { dir = current.peon.dir; pos = (x, y - 1)}
    | DOWN-> { dir = current.peon.dir; pos = (x, y + 1)}
    | LEFT-> { dir = current.peon.dir; pos = (x - 1, y)}
    | RIGHT -> { dir = current.peon.dir; pos = (x + 1, y)}

let new_dir (peon: guard) : direction = match peon.dir with
  UP -> RIGHT
  | DOWN -> LEFT
  | LEFT -> UP
  | RIGHT -> DOWN

let equal_positions (p1: position) (p2: position): bool =
  let (x1,y1) = p1 in
  let (x2,y2) = p2 in
  x1 = x2 && y1 = y2

let equal_dir (dir1: direction) (dir2: direction) = match dir1, dir2 with
  (UP, UP) | (DOWN, DOWN) | (LEFT,LEFT) | (RIGHT, RIGHT) -> true
  | (_, _) -> false
 
let equal_guard (peon1: guard) (peon2: guard) : bool =
  let (x1,y1) = peon1.pos in
  let (x2,y2) = peon2.pos in
  x1 = x2 && y1 = y2 && (equal_dir peon1.dir peon2.dir)

let rec handle_game (current: data) : position list =
  let new_guard = move_guard current in
    let (x,y) = new_guard.pos in
  if y < 0 || y >= Array.length current.board || x < 0 || x >= Array.length current.board.(0)
    then
       current.peon.pos::current.played
    else if Char.equal current.board.(y).(x) '#'
    then
      let new_guard = {dir = new_dir current.peon; pos = current.peon.pos} in
      handle_game {board = current.board; peon = new_guard; played = current.played}
    else
      let old_pos = current.peon.pos in
      if List.exists ~f:(equal_positions old_pos) current.played
      then
        handle_game {board = current.board; peon = new_guard; played = current.played}
      else
        handle_game {board = current.board; peon = new_guard; played = old_pos::current.played}

let solve_part1 (Input i : input): answer = i
  |> handle_game
  |> fun x -> Answer (List.length x)

let update_board (current: map) (pos: position) =
  let (x, y) = pos in
  current
  |> Array.mapi ~f:(fun idy line -> if idy <> y then line else Array.mapi ~f:(fun idx it -> if idx = x then '#' else it) line)

let handle_game_updated (curr: data) (new_block: position) : bool =
  let rec handle_game_2 (current: data) (played_guard: guard list) =
    let new_guard = move_guard current in
      let (x,y) = new_guard.pos in
    if y < 0 || y >= Array.length current.board || x < 0 || x >= Array.length current.board.(0)
      then
        false
      else if Char.equal current.board.(y).(x) '#'
      then
        let new_guard = {dir = new_dir current.peon; pos = current.peon.pos} in
        handle_game_2 {board = current.board; peon = new_guard; played = current.played} played_guard
      else
        if List.exists ~f:(equal_guard new_guard) played_guard
        then
          true
        else
          let old_pos = current.peon.pos in
          handle_game_2 {board = current.board; peon = new_guard; played = old_pos::current.played} (current.peon::played_guard)
  in handle_game_2 {board = (update_board curr.board new_block); peon = curr.peon; played = curr.played} []

let solve_part2 (Input i : input): answer = i
  |> handle_game
  |> List.rev
  |> fun x -> List.drop x 1
  |> List.filter ~f:(handle_game_updated i)
  |> fun x -> Answer (List.length x)

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
