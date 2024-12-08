open Base

type position = (int * int)
type antenna = {sort: char; pos: position}
type antennas_table = (char, antenna list) Hashtbl.t
type game = {board: char array array; antennas: antennas_table}

type input = Input of game
type answer = Answer of int | Unknown

let print_line line = line
  |> Array.map ~f:(fun x -> Stdio.Out_channel.output_string Stdio.stdout (Char.to_string x))

let print_board board = board
  |> Array.map ~f:(fun x -> let _ = print_line x in Stdio.Out_channel.output_string Stdio.stdout "\n")

let print_antenna antenna =
  let _ = Stdio.Out_channel.output_string Stdio.stdout "Antenna => " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout "Type : " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout (Char.to_string antenna.sort) in
  let _ = Stdio.Out_channel.output_string Stdio.stdout " Position : " in
  let (x, y) = antenna.pos in
  let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string x) in
  let _ = Stdio.Out_channel.output_string Stdio.stdout " / " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string y) in
  Stdio.Out_channel.output_string Stdio.stdout "\n"

let print_antennas antennas =
  List.map antennas ~f:print_antenna

let print_board_antennas game =
  let _ = Stdio.Out_channel.output_string Stdio.stdout "Board => " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout "\n" in
  let _ = game.antennas
    |> Hashtbl.mapi ~f:(fun ~key:_ ~data:data -> print_antennas data) in
  let _ = Stdio.Out_channel.output_string Stdio.stdout "\n" in
  Stdio.Out_channel.output_string Stdio.stdout "\n"

let change_key antenna = function
  Some items -> Some (antenna::items)
  | _ -> Some (antenna::[])

let process_board (board: char array array) =
  let hshtbl = Hashtbl.create (module Char) in
    let rec process_board line_nb col_nb =
      if line_nb >= Array.length board then
        { board = board; antennas = ( hshtbl) }
      else
        if col_nb >= Array.length board.(line_nb) then
          process_board (line_nb + 1) 0
        else
          if Char.equal board.(line_nb).(col_nb) '.' then
            process_board line_nb (col_nb + 1)
          else
            let antenna = {sort = board.(line_nb).(col_nb); pos = (col_nb, line_nb) } in
            let _ = Hashtbl.change ~f:(fun x -> change_key antenna x) hshtbl board.(line_nb).(col_nb) in
            process_board line_nb (col_nb + 1)
    in process_board 0 0         

let same_pos_antennas antenna1 antenna2 =
  let (x1,y1) = antenna1.pos in
  let (x2,y2) = antenna2.pos in
  x1 = x2 && y1 = y2

let text_to_input (txt: string) : input = txt
  |> String.split_lines
  |> List.map ~f:String.to_array
  |> List.to_array
  |> process_board
  |> fun x -> Input x

let compute_line_equation antenna1 antenna2 =
  let (x1,y1) = antenna1.pos in
  let (x2,y2) = antenna2.pos in
  let diffx = Int.abs(x2 - x1) in
  let diffy = Int.abs(y2 - y1) in
  if y2 > y1 then
    let ret1 = {sort = antenna1.sort; pos = (x1 - diffx, y1 - diffy)} in
    let ret2 = {sort = antenna1.sort; pos = (x2 + diffx, y2 + diffy)} in
    (ret1, ret2)
  else
    let ret1 = {sort = antenna1.sort; pos = (x1 - diffx, y1 + diffy)} in
    let ret2 = {sort = antenna1.sort; pos = (x2 + diffx, y2 - diffy)} in
    (ret1, ret2)

let get_new_antennas acc antenna1 antenna2 =
  let (x1, y1) = antenna1.pos in
  let (x2, y2) = antenna2.pos in
    if (x1 = x2 && y1 = y2) || x1 > x2 then acc
    else let (ret1, ret2) = compute_line_equation antenna1 antenna2 in ret1::ret2::acc

let compute_antenna_list antenna antennas = antennas
  |> List.fold_left ~init:[] ~f:(fun acc ant -> get_new_antennas acc antenna ant)

let compute_antennas antennas = antennas
  |> List.map ~f:(fun x -> compute_antenna_list x antennas)
  |> List.fold_left ~init:[] ~f:(fun acc x -> acc @ x)

let filter_antenna board antenna antennas =
  if List.exists antennas ~f:(fun x -> same_pos_antennas x antenna) then false
  else
    let (x, y) = antenna.pos in
      (x >= 0 && x <= (Array.length board.(0)) && y >= 0 && y < (Array.length board))

let solve_part1 (Input i : input) : answer = 
  let antennas = Hashtbl.to_alist i.antennas
    |> List.fold_left ~init:[] ~f:(fun acc item -> let (_, data) = item in acc @ data) in
  i.antennas
  |> Hashtbl.fold ~init:[] ~f:(fun ~key:_ ~data:items acc -> acc @ compute_antennas items)
  |> List.filter ~f:(fun x -> filter_antenna i.board x antennas)
  |> List.length
  |> fun x -> Answer x

let rec all_left acc x1 x2 y1 y2 sort max_y=
  let diffx = Int.abs(x2 - x1) in
  let diffy = Int.abs(y2 - y1) in
  let newx = x1 - diffx in
  if newx < 0 then acc
  else
    if y2 > y1 then
      let newy = y1 - diffy in
        if newy < 0 then acc
        else
          all_left ({sort = sort; pos = (newx, newy)}::acc) newx x1 newy y1 sort max_y
    else
      let newy = y1 + diffy in
        if newy >= max_y  then acc
        else
          all_left ({sort = sort; pos = (newx, newy)}::acc) newx x1 newy y1 sort max_y

let rec all_right acc x1 x2 y1 y2 sort max_x max_y=
  let diffx = Int.abs(x2 - x1) in
  let diffy = Int.abs(y2 - y1) in
  let newx = x2 + diffx in
  if newx >= max_x then acc
  else
    if y2 > y1 then
      let newy = y2 + diffy in
        if newy >= max_y then acc
        else
          all_right ({sort = sort; pos = (newx, newy)}::acc) x2 newx y2 newy sort max_x max_y
    else
      let newy = y2 - diffy in
        if newy < 0 then acc
        else
          all_right ({sort = sort; pos = (newx, newy)}::acc) x2 newx y2 newy sort max_x max_y

let compute_line_equation_2 antenna1 antenna2 max_x max_y=
  let (x1,y1) = antenna1.pos in
  let (x2,y2) = antenna2.pos in
  let items_left = all_left [] x1 x2 y1 y2 antenna1.sort max_y in
  let items_right = all_right [] x1 x2 y1 y2 antenna1.sort max_x max_y in
  items_left @ items_right

let get_new_antennas_2 acc antenna1 antenna2 max_x max_y =
  let (x1, y1) = antenna1.pos in
  let (x2, y2) = antenna2.pos in
    if (x1 = x2 && y1 = y2) || x1 > x2 then acc
    else let news = compute_line_equation_2 antenna1 antenna2 max_x max_y in news @ acc

let compute_antenna_list_2 antenna antennas max_x max_y = antennas
  |> List.fold_left ~init:[] ~f:(fun acc ant -> get_new_antennas_2 acc antenna ant max_x max_y)

let compute_antennas_2 antennas max_x max_y = antennas
  |> List.map ~f:(fun x -> compute_antenna_list_2 x antennas max_x max_y)
  |> List.fold_left ~init:[] ~f:(fun acc x -> acc @ x)

let unique (lst: antenna list) =
  let rec aux (l: antenna list) (acc: antenna list) =
    match l with
    | [] -> List.rev acc
    | h :: t ->
        if List.mem ~equal:(fun x y -> same_pos_antennas x y) acc h
          then aux t acc else aux t (h :: acc)
  in
  aux lst []

let solve_part2 (Input i : input) : answer = 
  let antennas = Hashtbl.to_alist i.antennas
    |> List.fold_left ~init:[] ~f:(fun acc item -> let (_, data) = item in acc @ data) in
  i.antennas
  |> Hashtbl.fold ~init:[] ~f:(fun ~key:_ ~data:items acc -> acc @ compute_antennas_2 items (Array.length i.board.(0)) (Array.length i.board))
  |> List.filter ~f:(fun x -> filter_antenna i.board x antennas)
  |> unique
  |> List.length
  |> fun x -> Answer (x + (List.length antennas)) 

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
