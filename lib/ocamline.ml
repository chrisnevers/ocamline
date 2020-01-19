let _trim_delim   = ref false
let _prompt       = ref ">"
let _init         = ref false
let _history_loc  = ref ""

(* Generate a string of spaces with a length of [n] *)
let rec spaces = function
  | 0 -> ""
  | n -> " " ^ spaces (n - 1)

let is_true x = x = true

(*
  [explode s]: Returns a character array of the string [s]
*)
let explode s =
  let rec aux l = function
    | i when i < 0 -> l
    | i -> aux (s.[i] :: l) (i - 1) in
  aux [] (String.length s - 1)

(*
  [ends_with s d ds]: Checks if the string [s] ends
  with the string [d], whose length is [ds]
*)
let ends_with s d ds =
  let ss = String.length s in
  let rec aux = function
    | i when i > 0 ->
      let a = s.[ss - i] in
      let b = d.[ds - i] in
      a = b && aux (i - 1)
    | _ -> true in
  if ss = 0 || ss < ds then false else aux ds

(* Counts how many time a character appears in a string *)
let count_char c strings str =
  let rec aux ?(escaped=false) ?(in_str=false) count = function
  | [] -> count
  (* If we start reading a string delim, turn on in_str *)
  | h :: t when List.mem h strings && in_str = false ->
    aux count t ~in_str:true
  (* If we read a string delim in_str and it's not escaped, turn off in_str *)
  | h :: t when List.mem h strings && in_str = true && escaped = false ->
    aux count t ~in_str:false
  (* If we read a string delim in_str and it's escaped, continue *)
  | h :: t when List.mem h strings && in_str = true && escaped = true ->
    aux count t ~in_str:in_str
  (* If we read an escape char and escape is off, turn on escape *)
  | '\\' :: t when escaped = false ->
    aux count t ~escaped:true ~in_str:in_str
  (* If we read a bracket, but we're in a string, continue *)
  | h :: t when h = c && in_str = true ->
    aux count t ~in_str:in_str
  (* If we read a bracket, count it! *)
  | h :: t when h = c ->
    aux (count + 1) t ~in_str:in_str
  | _ :: t ->
    aux count t ~in_str:in_str
  in
  aux 0 str

(*
  [any_open_strings s brackets strings env]: returns whether there
  are any open strings and the current environment to use during
  the next line process.
 *)
let any_open_strings s brackets strings env =
  let open List in
  let is_open, env' = split @@ map (fun (o, c) ->
    let opened = (assoc o env) + (count_char o strings s) in
    let closed = (assoc c env) + (count_char c strings s) in
    let is_open = opened - closed != 0 in
    is_open, [(o, opened); (c, closed)]
  ) brackets in
  exists is_true is_open, concat env'

(*
  If the user wants to keep their delimiter in their string, e.g. "end" or
  ";", then keep it in the return value.
  *)
let get_final_line str delim_length =
  let open String in
  match !_trim_delim with
  | true  -> sub str 0 (length str - delim_length)
  | false -> str

(* This will be executed after every line read *)
let lnoise_callback from_user =
    LNoise.history_add from_user |> ignore;
    LNoise.history_save ~filename:!_history_loc |> ignore;
    from_user

let rec read_input prompt delim ds brackets strings env =
  (* Read a line from stdin and add it to user history *)
  let s = match LNoise.linenoise prompt with
    | None   -> exit 0
    | Some s -> lnoise_callback s
  in
  match s = "" with
  | true -> read_input prompt delim ds brackets strings env
  | false ->
    (* Store it as a char array *)
    let x = explode s in
    (* See if there are any open brackets and update our env *)
    let any_open, env' = any_open_strings x brackets strings env in
    (* If there are no open and brackets and we read the delimiter, return. *)
    match not any_open && ends_with s delim ds with
    | true -> get_final_line s ds
    | false ->
      (*
        Otherwise, continue reading input. The prompt will now be
        spaces equal to the length of the original prompt, until
        the user finishes the current entry.
      *)
      let prompt = spaces (String.length !_prompt) in
      (* append current input to future input *)
      s ^ "\n" ^ read_input prompt delim ds brackets strings env'

(*
  [init history_loc] initializes the Linenoise utility. Stores the history
  of user commands to [history_loc]
 *)
let init history_loc hints_callback completion_callback =
  _history_loc := history_loc;
  LNoise.history_load ~filename:history_loc |> ignore;
  LNoise.history_set ~max_length:100 |> ignore;
  LNoise.set_hints_callback hints_callback;
  LNoise.set_completion_callback completion_callback;
  _init := true

(* We've seen 0 of each bracket so far *)
let default_env b = List.concat @@ List.map (fun (o, c) -> [o, 0; c, 0]) b

(*
  [read ?trim_delim ?brackets ?prompt ?history_loc ?delim ?hints_callback ?completion_callback  ()]
  will read input from stdin until a new line or [delim] string is encountered.
  Occurrences of [delim] not at the end of the line will not stop the input
  process. The history of the user's commands will be saved to history_loc by
  Linenoise.

  If [delim] is an empty string, it will return on new lines.
  *)
let read
    ?(trim_delim=false)
    ?(brackets=[])
    ?(prompt=">")
    ?(strings=[])
    ?(history_loc=".ocamline_history.txt")
    ?(hints_callback=(fun _ -> None))
    ?(completion_callback=(fun _ _ -> ()))
    ?(delim="")
    ()
=
  (* Initialize the Linenoise library *)
  if not !_init then init history_loc hints_callback completion_callback;
  (* Get length of delimiter string *)
  let ds = String.length delim in
  (* Store info as references for efficiency *)
  _trim_delim := trim_delim;
  _prompt := prompt ^ " ";
  (* Initial environment *)
  let env = default_env brackets in
  (* Do work! *)
  read_input !_prompt delim ds brackets strings env
