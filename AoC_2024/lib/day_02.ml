open Base

type report = int list

type input = Input of report list 
type answer = Answer of int | Unknown

let parse_one_line (line: string) : (int list) =
  let split = Str.split (Str.regexp " +") line in
  List.map ~f:Int.of_string split

let text_to_input (txt: string): input = txt
  |> String.split_lines
  |> List.map ~f:parse_one_line
  |> fun x -> Input x

let check_bool (left: bool) (right: bool) : bool = match left, right with
  (true, true) | (false, false) -> false
  | (_, _) -> true 

let check_safe (lst: int list): bool = match lst with
  [] | _::[] -> failwith "error"
  | a::b::r -> if Int.abs(a - b) > 3 || a = b then false else let incr = (a < b) in
      let rec check (acc: bool) (lt: int list): bool = match lt with
        [] | _::[] -> true
        | x::y::r -> if Int.abs(x - y) > 3 || x = y
          then false
          else if (check_bool acc (x < y))
            then false
            else check acc (y::r)
      in check incr (b::r)

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let solve_part1 (Input i : input): answer =
  let rec count_safe lst = match lst with
    [] -> 0
    | a::r -> let resp = (if check_safe a then 1 else 0) in
      resp + count_safe r
  in Answer (count_safe i)

let myReverse lst = let rec remrev acc ls = match ls with
  | [] -> acc 
  | item :: rest -> remrev (item::acc) rest
in remrev [] lst

let remove (lst: int list) (idx: int) = match lst with
  [] -> []
  | _ -> 
    let rec rem acc ls id = match ls with
      [] -> []
      | a::r -> if id = 0
        then (myReverse acc) @ r
        else rem (a::acc) r (id - 1)
    in rem [] lst idx

let big_check (lst: int list) =
  let rec remover (ls: int list) (idx: int) =
    let nl = (remove ls idx) in
      if (List.is_empty nl) then false else
        if check_safe nl then true
        else remover ls (idx + 1)
  in remover lst 0 

let solve_part2 (Input i : input): answer =
  let rec count_safe lst = match lst with
    [] -> 0
    | a::r -> let chck = check_safe a in
      if chck then 1 + count_safe r else (if big_check a then 1 else 0) + count_safe r
  in Answer (count_safe i)

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text

