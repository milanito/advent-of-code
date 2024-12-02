open Base

type couple = (int list * int list)

type input = Input of couple
type answer = Answer of int | Unknown

let rec first_last (mList: int list) : (int * int) = match mList with
  [] -> failwith "empty list"
  | _::[] -> failwith "only one"
  | [e1;e2] -> (e1,e2)
  | e::_::r -> first_last (e::r)

let parse_one_line (line: string) : (int * int) =
  let split = Str.split (Str.regexp " +") line in
  let lst = List.map ~f:Int.of_string split in
  first_last lst

let sort_lists (lists: (int list * int list)): (int list * int list) =
  let (l1, l2) = lists in
  (List.sort ~compare:Int.compare l1, List.sort ~compare:Int.compare l2)

let get_distance (couple : (int * int)) : int =
  let (x, y) = couple in
  Int.abs(x - y)

let splitList (lst : (int * int) list) : (int list * int list) =
  let rec splt acc l = match l with
    [] -> acc
    | e::r -> let (a,b) = e in
              let (acc1, acc2) = acc in splt (a::acc1, b::acc2) r
  in splt ([],[]) lst

let combineList (lsts : (int list * int list)) : (int * int) list =
  let rec cmbn acc l = match l with
    ([], []) -> acc
    | (_, []) | ([], _) -> failwith "error"
    | (e1::r1, e2::r2) -> cmbn ((e1,e2)::acc) (r1, r2)
  in cmbn [] lsts

let solve_part1 (Input i : input) : answer = i
  |> combineList
  |> List.map ~f:get_distance
  |> List.fold_left ~init:0 ~f:(fun x y -> x + y)
  |> (fun x -> Answer x)


let rec how_many (lst: int list) (num : int) : int = match lst with
  [] -> 0
  | e :: r -> (if e = num then 1 else 0) + (how_many r num)

let rec similarityScore (l1: int list) (l2: int list) : int = match (l1, l2) with
  ([], []) -> 0
  |(_, [])|([], _) -> failwith "error"
  |(e1::r1, e2::r2) -> e1*e2 + (similarityScore r1 r2)

let solve_part2 (Input i : input) : answer =
  let (lst1, lst2) = i in
  let totals = List.map ~f:(how_many lst2) lst1 in
  Answer (similarityScore lst1 totals)

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let text_to_input (txt: string) : input = txt
  |> String.split_lines
  |> List.map ~f:parse_one_line
  |> splitList
  |> sort_lists
  |> fun x -> Input x

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
