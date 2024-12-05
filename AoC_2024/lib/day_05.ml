open Base
open Re

type couple = (int * int)
type sequence = int list
type data = {couples: couple list; sequences: sequence list}

type input = Input of data
type answer = Answer of int | Unknown 

let debug_str (str: string) = 
  let _ = Stdio.Out_channel.output_string Stdio.stdout str in
   Stdio.Out_channel.output_string Stdio.stdout "\n"

let rec print_sequence (sequence: sequence) = match sequence with
  [] -> Stdio.Out_channel.output_string Stdio.stdout "\n"
  | e::r ->
    let _ = Stdio.Out_channel.output_string Stdio.stdout (Int.to_string e) in
    let _ = Stdio.Out_channel.output_string Stdio.stdout "," in
    print_sequence r
  
let rec print_sequences (seqs: sequence list) = match seqs with
  [] -> Stdio.Out_channel.output_string Stdio.stdout "\n"
  | e::r -> let _ = print_sequence e in print_sequences r

let myReverse lst = let rec remrev acc ls = match ls with
  | [] -> acc
  | item :: rest -> remrev (item::acc) rest
in remrev [] lst

let answer_to_text = function
  | Answer x -> Int.to_string x
  | Unknown  -> "Solution not yet implemented"

let parse_one_line (acc : data) (str: string) : data = 
  let rex = Pcre.regexp {ext|^([0-9]+)\|([0-9]+)$|ext} in
    if execp rex str
    then 
      let extracted = Pcre.extract ~rex:rex str in
        { couples = (Int.of_string extracted.(1), Int.of_string extracted.(2)) :: acc.couples; sequences = acc.sequences }
    else
      let rex = Pcre.regexp {|[0-9]+|} in
      if execp rex str 
      then
        let sequence = all rex str 
          |> List.map ~f:(fun g -> Re.Group.all g)
          |> List.fold_left ~init:[] ~f:(fun acc item -> item.(0)::acc)
          |> List.map ~f:(fun g -> Int.of_string g)
          |> myReverse
        in
          { couples = acc.couples; sequences = (acc.sequences @ [sequence]) }
      else
      { couples = acc.couples; sequences = acc.sequences }

let text_to_input (txt: string): input = txt
  |> String.split_lines
  |> List.fold_left ~init: { couples = []; sequences = [] } ~f:parse_one_line
  |> fun x -> Input x

let rec is_in (seq : sequence) (num: int) : bool =
  match seq with
    [] -> false
    | e::r -> e = num || (is_in r num)

let rec is_in_list (seq: sequence) (nums: int list): bool =
  match nums with
  [] -> false
  | a::r -> is_in seq a || is_in_list seq r

let rec is_in_list_int (seq: sequence) (nums: int list): int =
  match nums with
  [] -> -1
  | a::r -> if is_in seq a then a else is_in_list_int seq r

let rec is_in_first (num: int) (couples: couple list) (acc: int list) : int list =
  match couples with
    [] -> acc
    | e::r -> let (a,b) = e in if a = num then (is_in_first num r (b::acc)) else (is_in_first num r acc)

let rec is_in_last (num: int) (couples: couple list) : int =
  match couples with
    [] -> -1
    | e::r -> let (a,b) = e in if b = num then a else (is_in_last num r)

let rec check_sequence (couples: couple list) (played: sequence) (seq : sequence) : bool =
  match seq with
    [] -> true
    | e::r -> let acc = is_in_first e couples [] in
      match acc with
        [] -> check_sequence couples (e::played)  r
        | _ -> if is_in_list played acc then false else check_sequence couples (e::played) r

let rec check_sequence_couple (couples: couple list) (played: sequence) (seq : sequence) : couple =
  match seq with
    [] ->(-1, -1) 
    | e::r -> let acc = is_in_first e couples [] in
      match acc with
        [] -> check_sequence_couple couples (e::played)  r
        |_ -> let last = is_in_list_int played acc in 
          if last = -1 then check_sequence_couple couples (e::played) r else (e, last)

let middle (seq: sequence) : int = 
  let res = List.nth seq (List.length seq / 2) in match res with
    None -> 0
    | Some x -> x

let solve_part1 (Input i : input): answer = 
  List.filter ~f:(check_sequence i.couples []) i.sequences
  |> List.fold_left ~init: 0 ~f:(fun (acc: int) (seq: sequence) -> acc + (middle seq))
  |> fun x -> Answer x

let rec insert (x: int) (lst: sequence) =
  match lst with
  | [] -> [[x]]
  | h::t -> (x::lst) :: (List.map ~f:(fun el -> h::el) (insert x t))

let swap u v x = if x = u then v else if x = v then u else x
let list_swap (u: int) (v: int) = List.map ~f:(swap u v)

let rec get_right_perm (couples: couple list) (seq: sequence) : sequence =
  if check_sequence couples [] seq then
    seq
  else
    let (u, v) = check_sequence_couple couples [] seq in
      get_right_perm couples (list_swap u v seq)

let solve_part2 (Input i : input): answer = 
  List.filter ~f:(fun seq -> not (check_sequence i.couples [] seq)) i.sequences
  |> List.map ~f:(get_right_perm i.couples)
  |> List.fold_left ~init: 0 ~f:(fun (acc: int) (seq: sequence) -> acc + (middle seq))
  |> fun x -> Answer x

let part1 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part1 |> answer_to_text

let part2 (input_text: string) : (string) =
  input_text |> text_to_input |> solve_part2 |> answer_to_text
