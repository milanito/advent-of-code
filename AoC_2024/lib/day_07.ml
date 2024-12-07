open Base
open Re

type data = { result: int; items: int list}

type input = Input of data list
type answer = Answer of int | Unknown

let debug_str (str: string) =
  let _ = Stdio.Out_channel.output_string Stdio.stdout str in
   Stdio.Out_channel.output_string Stdio.stdout "\n"

let print_int (it: int) =
  Stdio.Out_channel.output_string Stdio.stdout (Int.to_string it)

let rec print_list (items: char list) = match items with
  [] -> Stdio.Out_channel.output_string Stdio.stdout "\n"
  | e::r -> let _ = Stdio.Out_channel.output_char Stdio.stdout e in print_list r

let rec print_items (strs: int list) = match strs with
  [] -> debug_str ""
  | e::r -> let _ = print_int e in
    let _ = Stdio.Out_channel.output_string Stdio.stdout ", " in
    print_items r

let print_data (item: data) =
  let _ = Stdio.Out_channel.output_string Stdio.stdout "Data => " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout "Result : " in
  let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string item.result) in
  let _ = Stdio.Out_channel.output_string Stdio.stdout " Items : " in
  let _ = print_items item.items in
   Stdio.Out_channel.output_string Stdio.stdout "\n"

let parse_int (str: string) : int list =
  let rex = Pcre.regexp {|[0-9]+|} in
    all rex str
      |> List.map ~f:(fun g -> Re.Group.all g)
      |> List.fold_left ~init:[] ~f:(fun acc item -> item.(0)::acc)
      |> List.map ~f:(fun g -> Int.of_string g)

let construct_data (strs: int list) : data = match strs with
    e::r  -> {result = e; items = (List.rev r)}
  | _  -> {result = 0; items = []}

let parse_one_line (line: string) : data  = line
  |> String.split ~on:':'
  |> List.map ~f:(parse_int)
  |> List.fold_left ~init:[] ~f:(fun acc it -> List.append acc it)
  |> construct_data

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let text_to_input (txt: string) : input = txt
  |> String.split_lines
  |> List.map ~f:parse_one_line
  |> fun x -> Input x

let rec mySigns (it: int) : char list list = match it with
  | 0 -> [[]]
  | n ->
     let lst = mySigns (n - 1) in
     (List.map ~f:(fun l -> '*' :: l) lst) @ (List.map ~f:(fun l -> '+' :: l) lst)

let rec mySigns2 (it: int) : char list list = match it with
  | 0 -> [[]]
  | n ->
     let lst = mySigns2 (n - 1) in
     (List.map ~f:(fun l -> '*' :: l) lst) @ (List.map ~f:(fun l -> '+' :: l) lst) @ (List.map ~f:(fun l -> '|' :: l) lst)

let concat_int (a: int) (b: int) : int =
  Int.of_string (String.concat [(Int.to_string a);(Int.to_string b)])
 
let rec get_comb (comb : char list) (items: int list) =
  match items with
    [] -> 0
    | e::[] -> e
    | a::b::r -> let s::res = comb in
      if Char.equal s '+'
        then get_comb res ((a + b)::r)
        else if Char.equal s '*' then get_comb res ((a * b)::r)
        else get_comb res ((concat_int a b)::r)

let check_comb (item: data) (comb: char list): bool =
  let res = get_comb comb item.items in
    res = item.result

let checker = function
  None -> false
  | _ -> true

let check_data (item: data) = 
  mySigns (List.length item.items - 1)
  |> List.filter ~f:(fun x -> List.length x = (List.length item.items - 1))
  |> List.find ~f:(check_comb item)
  |> checker

let check_data2 (item: data) = 
  mySigns2 (List.length item.items - 1)
  |> List.filter ~f:(fun x -> List.length x = (List.length item.items - 1))
  |> List.find ~f:(check_comb item)
  |> checker

let solve_part1 (Input i : input) : answer = i
  |> List.filter ~f:(fun x -> check_data x)
  |> List.fold_left ~init:0 ~f:(fun acc x -> acc + x.result)
  |> fun x -> Answer x

let solve_part2 (Input i : input) : answer =  i
  |> List.filter ~f:(fun x -> check_data2 x)
  |> List.fold_left ~init:0 ~f:(fun acc x -> acc + x.result)
  |> fun x -> Answer x

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
