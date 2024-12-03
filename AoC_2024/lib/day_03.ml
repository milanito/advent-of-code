open Base
open Re

type couple = (int * int)

type input = Input of couple list
type answer = Answer of int | Unknown

let myReverse lst = let rec remrev acc ls = match ls with
  | [] -> acc
  | item :: rest -> remrev (item::acc) rest
in remrev [] lst

let parse_one_line (line: string) : (string list) = 
  let rex = Pcre.regexp {|mul\([0-9]+,[0-9]+\)|} in
      all rex line
      |> List.map ~f:(fun g -> Re.Group.all g)
      |> List.fold_left ~init:[] ~f:(fun acc item -> item.(0)::acc)

let parse_one_line_2 (line: string) : (string list) = 
  let rex = Pcre.regexp {|don't\(\)|do\(\)|mul\([0-9]+,[0-9]+\)|} in
      all rex line
      |> List.map ~f:(fun g -> Re.Group.all g)
      |> List.fold_left ~init:[] ~f:(fun acc item -> item.(0)::acc)
      |> myReverse

let transform_item (item: string) : couple = match item with
  "don't()" -> (-1,1)
  | "do()" -> (0,0)
  | _ ->
    let rex = Pcre.regexp {|([0-9]+),([0-9]+)|} in
      let extracted = Pcre.extract ~rex:rex item in
        (Int.of_string extracted.(1), Int.of_string extracted.(2))

let text_to_input (txt: string): input = txt
  |> String.split_lines
  |> List.map ~f:parse_one_line
  |> List.fold_left ~init:[] ~f:(fun acc item -> item @ acc)
  |> List.map ~f:transform_item
  |> fun x -> Input x

let text_to_input_2 (txt: string): input = txt
  |> String.split_lines
  |> List.map ~f:parse_one_line_2
  |> List.fold_left ~init:[] ~f:(fun acc item -> item @ acc)
  |> List.map ~f:transform_item
  |> fun x -> Input x

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let sum_items (items : couple) =
  let (a, b) = items in (a * b)


let calculate_instr (acc : int) (items : couple) : int = acc + (sum_items items)

let rec handle_2 (acc : int) (should: bool) (items: couple list) : int = match items with
  [] -> acc
  | e::r -> let sit = sum_items e in
    if sit = 0 then handle_2 acc true r
    else
      if sit = -1 then handle_2 acc false r
      else if should then handle_2 (acc + sit) should r else handle_2 acc should r

let solve_part1 (Input i : input): answer = i
  |> List.fold_left ~init:0 ~f:calculate_instr
  |> fun x -> Answer x

let solve_part2 (Input i : input): answer = i
  |> handle_2 0 true
  |> fun x -> Answer x

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input_2 |> solve_part2 |> answer_to_text
