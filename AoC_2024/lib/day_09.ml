open Base

type input = Input of string list
type answer = Answer of int | Unknown

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let rec debug_str_list (str: string list) = match str with
  [] -> Stdio.Out_channel.output_string Stdio.stdout "\n"
  | a::r-> let _ = Stdio.Out_channel.output_string Stdio.stdout a in
    let _ = Stdio.Out_channel.output_string Stdio.stdout " " in
    debug_str_list r 
   
let rec compute_from_id (ch: string) (idx: int) (acc: string list): string list =
  if idx = 0
  then
    acc
  else
    compute_from_id ch (idx - 1) (ch::acc)

let process_line (idx: int) (acc: string list) (ch: char): string list =
  let total = Int.of_string (Char.to_string ch) in
  if idx % 2 = 0
  then
    let id = idx / 2 in
    acc @ (compute_from_id (Int.to_string id) total [])
  else
    acc @ (compute_from_id "." total [])

let text_to_input (txt: string) : input = txt
  |> String.foldi ~init:[] ~f:(process_line)
  |> fun x -> Input x

let count_points (strs: string list) : int = strs
  |> List.fold_left ~init:0 ~f:(fun acc x -> if String.equal x "." then acc + 1 else acc)

let get_elements (strs: string list) : string list = strs
  |> List.rev
  |> List.fold_left ~init:"" ~f:(fun acc x -> if String.equal x "." then acc else String.concat [acc;x])
  |> String.to_list
  |> List.map ~f:(Char.to_string)

let rec process_filesystem (acc: string list) (base: string list) (fill: string list): string list =
  match base with
  [] -> List.rev acc
  | e::r -> if String.equal e "."
    then
      match fill with
        [] -> List.rev acc
        | a::c -> process_filesystem (a::acc) r c
    else
      process_filesystem (e::acc) r fill

let solve_part1 (Input i : input) : answer = 
  let _ = debug_str_list i in
  let points = count_points i in
  let elts = get_elements i in
  let data = process_filesystem [] i elts in
  let _ = debug_str_list data in
  List.take data (List.length i - points)
  |> List.foldi ~init:0 ~f:(fun i acc x -> acc + (i * (Int.of_string x)))
  |> (fun x -> Answer x)

let solve_part2 (Input _ : input) : answer = Unknown 

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
