open Base
open Core

type input = Input of int list
type answer = Answer of int | Unknown

module IntPair = struct
  module T = struct
    type t = int * int
    let compare x y = Tuple2.compare ~cmp1:Int.compare ~cmp2:Int.compare x y
    let sexp_of_t = Tuple2.sexp_of_t Int.sexp_of_t Int.sexp_of_t
    let t_of_sexp = Tuple2.t_of_sexp Int.t_of_sexp Int.t_of_sexp
    let hash = Hashtbl.hash
  end

  include T
  include Comparable.Make(T)
end

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let rec print_list_string (items: string list) = match items with
  [] -> Stdio.Out_channel.output_string Stdio.stdout "\n"
  | e::r -> let _ = Stdio.Out_channel.output_string Stdio.stdout e in
            let _ = Stdio.Out_channel.output_string Stdio.stdout " " in  print_list_string r

let rec print_list_int (items: int list) = match items with
  [] -> Stdio.Out_channel.output_string Stdio.stdout "\n"
  | e::r -> let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string e) in
            let _ = Stdio.Out_channel.output_string Stdio.stdout " " in  print_list_int r

let text_to_input (txt: string) : input = txt
  |> String.split ~on:' '
  |> List.map ~f:(Int.of_string)
  |> fun x -> Input x

let divide_str (list_length: int) (idx: int) (acc: (char list * char list)) (item: char) =
  let (left, right) = acc in
  if idx < list_length / 2
  then
    (item::left, right)
  else
    (left, item::right)

let process_input (ints: int list) (times: int) hashtable =
  let rec process_item (item: int) (times: int) : int = 
    if times = 0
    then
      1
    else
    let data = Hashtbl.find hashtable (item, times) in
    match data with
      Some value -> value
      | None -> 
        if item = 0
        then
          let resp = process_item 1 (times - 1) in
          let _ = Hashtbl.set hashtable ~key:(item, times) ~data:resp in
          resp
        else
          let str = Int.to_string item in
          let str_length = (String.length str) in
          if str_length % 2 = 0
          then
            let resp = str
            |> String.foldi ~init:([], []) ~f:(divide_str str_length)
            |> fun x -> let (left, right) = x in (String.of_char_list (List.rev left), String.of_char_list (List.rev right))
            |> fun x -> let (left, right) = x in (process_item (Int.of_string left) (times - 1)) + (process_item (Int.of_string right) (times - 1))
            in
            let _ = Hashtbl.set hashtable ~key:(item, times) ~data:resp in
            resp
          else
            let resp = process_item (item * 2024) (times - 1) in
            let _ = Hashtbl.set hashtable ~key:(item, times) ~data:resp in
            resp
  in ints
  |> List.fold_left ~init:0 ~f:(fun acc x -> acc + (process_item x times))

let solve_part1 (Input i : input) : answer = 
  let hashtable = Hashtbl.create (module IntPair) in
  process_input i 25 hashtable
  |> fun x -> Answer x

let solve_part2 (Input i : input) : answer = 
  let hashtable = Hashtbl.create (module IntPair) in
  process_input i 75 hashtable
  |> fun x -> Answer x

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
