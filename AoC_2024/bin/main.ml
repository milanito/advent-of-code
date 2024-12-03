let usage_msg = {|AoC_2024 -day <day_number> [-input <puzzle_input_file>]

example 1: AoC_2024 -day 2 -file ./input/day22
example 2: cat ./input/day22 | AoC_2024 -day 2

Command line utility to execute calculations of Advent of Code 2024 puzzles. Advent of Code puzzles are available by URL: https://adventofcode.com/2024.
|}

let day = ref (-1)
let input_file = ref ""
let anon_fun filename = input_file := filename
let speclist =
  [
    ("-day", Arg.Set_int day, "Day number to solve");
    ("-file", Arg.Set_string input_file, "Puzzle input. Can be skipped if stdin is given as an input");
  ]

exception Invalid_day of string

let read_whole_input_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

(* this main function reads sandard input with puzzle data from file and returns standard output with answer *)
let () =
  let () = Arg.parse speclist anon_fun usage_msg in
  let (part1, part2) = match !day with
  |  1 -> AoC_2024.Day_01.(part1, part2)
  |  2 -> AoC_2024.Day_02.(part1, part2)
  |  3 -> AoC_2024.Day_03.(part1, part2)
  |  _ -> raise (Invalid_day "AoC day is not specified or is invalid, please make sure the -day parameter is provided and is between 1 and 25")
  in
  let open Stdio in
  let input_text = if String.equal !input_file ""
    then In_channel.input_all Stdio.stdin
    else read_whole_input_file !input_file
  in
  let answer1_text = input_text |> part1 in
  let answer2_text = input_text |> part2 in
  printf
    "\nPart 1 solution is: %s;\nPart 2 solution is: %s.\n"
    answer1_text answer2_text
