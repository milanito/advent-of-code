open Base

type line = char array

type input = Input of line array
type answer = Answer of int | Unknown

let parse_one_line (line: string) : (char array) = line
  |> String.to_array
  |> Array.map ~f:(fun x -> if (String.contains "XMAS" x) then x else '.')

let text_to_input (txt: string): input = txt
  |> String.split_lines
  |> List.map ~f:parse_one_line
  |> List.to_array
  |> fun x -> Input x

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let list_to_str (lst : char list) : string = lst
  |> List.fold_left ~init: "" ~f:(fun acc ch -> acc ^ String.make 1 ch)

let check_right_word (Input i : input) (x : int) (y : int) : int =
    if y < (Array.length i.(x) - 3) then
      let str = list_to_str [i.(x).(y); i.(x).(y + 1); i.(x).(y + 2); i.(x).(y + 3)] in
        if (String.compare str "XMAS") = 0
          then 1
          else 0
      else 0

let check_left_word (Input i : input) (x : int) (y : int) : int =
    if y > 2 then
      let str = (list_to_str [i.(x).(y); i.(x).(y - 1); i.(x).(y - 2); i.(x).(y - 3)]) in
      if (String.compare str "XMAS") = 0
        then 1
        else 0
    else 0

let check_top_word (Input i : input) (x : int) (y : int) : int =
    if x > 2 then
      let str = (list_to_str [i.(x).(y); i.(x - 1).(y); i.(x - 2).(y); i.(x - 3).(y)]) in
      if (String.compare str "XMAS") = 0
        then 1
        else 0
    else 0

let check_bottom_word (Input i : input) (x : int) (y : int) : int =
    if x < (Array.length i - 3) then
      let str = (list_to_str [i.(x).(y); i.(x + 1).(y); i.(x + 2).(y); i.(x + 3).(y)]) in
      if (String.compare str "XMAS") = 0
        then 1
        else 0
    else 0

let check_right_top_word (Input i : input) (x : int) (y : int) : int =
    if y < (Array.length i.(x) - 3) && x > 2 then
      let str = list_to_str [i.(x).(y); i.(x - 1).(y + 1); i.(x - 2).(y + 2); i.(x - 3).(y + 3)] in
        if (String.compare str "XMAS") = 0
          then 1
          else 0
      else 0

let check_right_bottom_word (Input i : input) (x : int) (y : int) : int =
    if y < (Array.length i.(x) - 3) && x < (Array.length i - 3) then
      let str = list_to_str [i.(x).(y); i.(x + 1).(y + 1); i.(x + 2).(y + 2); i.(x + 3).(y + 3)] in
        if (String.compare str "XMAS") = 0
          then 1
          else 0
      else 0

let check_left_bottom_word (Input i : input) (x : int) (y : int) : int =
    if y > 2 && x < (Array.length i - 3) then
      let str = list_to_str [i.(x).(y); i.(x + 1).(y - 1); i.(x + 2).(y - 2); i.(x + 3).(y - 3)] in
        if (String.compare str "XMAS") = 0
          then 1
          else 0
      else 0

let check_left_top_word (Input i : input) (x : int) (y : int) : int =
    if y > 2 && x > 2 then
      let str = list_to_str [i.(x).(y); i.(x - 1).(y - 1); i.(x - 2).(y - 2); i.(x - 3).(y - 3)] in
        if (String.compare str "XMAS") = 0
          then 1
          else 0
      else 0

let check_word (Input i : input) (x : int) (y : int) : int =
  if (Char.compare i.(x).(y) 'X') = 0
    then 
      let square = (check_right_word (Input i) x y) + (check_left_word (Input i) x y) + (check_top_word (Input i) x y) + (check_bottom_word (Input i) x y) in
      let diag = (check_right_top_word (Input i) x y) + (check_right_bottom_word (Input i) x y) + (check_left_top_word (Input i) x y) + (check_left_bottom_word (Input i) x y) in
      square + diag
    else 0

let check_xmas (Input i : input) (x : int) (y : int) : int =
  if (Char.compare i.(x).(y) 'A') = 0 && x < (Array.length i - 1) && x > 0 && y < (Array.length i.(x) - 1) && y > 0
    then
      if Char.compare i.(x - 1).(y - 1) 'M' = 0 && Char.compare i.(x + 1).(y - 1) 'M' = 0 && Char.compare i.(x - 1).(y + 1) 'S' = 0 && Char.compare i.(x + 1).(y + 1) 'S' = 0
      then 1
      else if Char.compare i.(x - 1).(y - 1) 'S' = 0 && Char.compare i.(x + 1).(y - 1) 'M' = 0 && Char.compare i.(x - 1).(y + 1) 'S' = 0 && Char.compare i.(x + 1).(y + 1) 'M' = 0
      then 1
      else if Char.compare i.(x - 1).(y - 1) 'S' = 0 && Char.compare i.(x + 1).(y - 1) 'S' = 0 && Char.compare i.(x - 1).(y + 1) 'M' = 0 && Char.compare i.(x + 1).(y + 1) 'M' = 0
      then 1
      else if Char.compare i.(x - 1).(y - 1) 'M' = 0 && Char.compare i.(x + 1).(y - 1) 'S' = 0 && Char.compare i.(x - 1).(y + 1) 'M' = 0 && Char.compare i.(x + 1).(y + 1) 'S' = 0
      then 1
      else 0
    else 0

let solve_part1 (Input i : input): answer =
  let rec check_col row col ip count =
    if col >= (Array.length ip.(row))
      then count
      else check_col row (col + 1) ip (count + (check_word (Input ip) row col))
  in
  let rec check_row row ip count = 
    if row >= (Array.length ip)
      then count
      else check_row (row + 1) ip (count + (check_col row 0 ip 0))
  in Answer (check_row 0 i 0)

let solve_part2 (Input i : input): answer =
  let rec check_col row col ip count =
    if col >= (Array.length ip.(row))
      then count
      else check_col row (col + 1) ip (count + (check_xmas (Input ip) row col))
  in
  let rec check_row row ip count = 
    if row >= (Array.length ip)
      then count
      else check_row (row + 1) ip (count + (check_col row 0 ip 0))
  in Answer (check_row 0 i 0)

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
