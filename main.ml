module type ReadLine = sig
  val read :  ?trim_delim:bool -> ?brackets:(char * char) list ->
              ?prompt:string -> ?strings:char list -> string -> string
end

module ReadLine : ReadLine = struct
  let _trim_delim = ref false
  let _prompt = ref ">"

  let _debug a b =
    print_string "A: ";
    print_char a;
    print_string " B : ";
    print_char b;
    print_endline ""

  let rec _spaces = function
    | 0 -> ""
    | n -> " " ^ _spaces (n - 1)

  let _is_true x = x = true

  (*
    [explode s]: Returns a character array of the string [s]
  *)
  let _explode s =
    let rec aux l = function
      | i when i < 0 -> l
      | i -> aux (s.[i] :: l) (i - 1) in
    aux [] (String.length s - 1)

  (*
    [ends_with s d ds]: Checks if the string [s] ends
    with the string [d], whose length is [ds]
  *)
  let _ends_with s d ds =
    let ss = String.length s in
    let rec aux = function
      | i when i > 0 ->
        let a = s.[ss - i] in
        let b = d.[ds - i] in
        (* _debug a b; *)
        a = b && aux (i - 1)
      | 0 -> true in
    aux ds

  (* Counts how many time a character appears in a string *)
  let _count_char c str =
    let rec aux count = function
    | [] -> count
    | h :: t when h = c -> aux (count + 1) t
    | _ :: t -> aux count t in
    aux 0 str

  let _any_open s brackets env =
    let isOpen, env' = List.split @@ List.map (fun (o, c) ->
      let opened = (List.assoc o env) + (_count_char o s) in
      let closed = (List.assoc c env) + (_count_char c s) in
      let isOpen = opened - closed != 0 in
      (* print_string @@ "Any Open: (";
      print_char o;
      print_string ", ";
      print_char c;
      print_string @@ "): " ^ string_of_bool isOpen;
      print_endline @@ "\nOpen: " ^ string_of_int opened;
      print_endline @@ "Closed: " ^ string_of_int closed ^ "\n"; *)
      isOpen, [(o, opened); (c, closed)]
    ) brackets in
    List.exists _is_true isOpen, List.concat env'

  (*
    If the user wants to keep their delimiter in their string, e.g. "end" or
    ";", then keep it in the return value.
   *)
  let _get_final_line str ds =
    if !_trim_delim
    then String.sub str 0 (String.length str - ds)
    else str

  let rec _read_input delim ds brackets strings env =
    (* Read a line from stdin *)
    let s = read_line () in
    (* Store it as a char array *)
    let x = _explode s in
    (* See if there are any open brackets and update our env *)
    let any_open, env' = _any_open x brackets env in
    (* If there are no open and brackets and we read the delimiter, return. *)
    if not any_open && _ends_with s delim ds
    then _get_final_line s ds
    (* otherwise, continue reading input *)
    else
      (* print indentation equal to the length of the prompt *)
      let _ = print_string @@ _spaces (String.length !_prompt + 1) in
      (* append current input to future input *)
      s ^ "\n" ^ _read_input delim ds brackets strings env'

  (*
    [read ?trim_delim ?brackets ?prompt delim] will read input from stdin
    until a new line or [delim] string is encountered. Occurrences of [delim]
    not at the end of the line will not stop the input process.

    If [delim] is an empty string, it will return on new lines.
   *)
  let read
      ?(trim_delim=false)
      ?(brackets=[])
      ?(prompt=">")
      ?(strings=[])
      delim
  =
    (* Print initial prompt *)
    print_string @@ prompt ^ " ";
    (* Get length of delimiter string *)
    let ds = String.length delim in
    (* Store info as references for efficiency *)
    _trim_delim := trim_delim;
    _prompt := prompt;
    (* Initial environment. We've read 0 of every bracket so far. *)
    let env = List.concat @@ List.map (fun (o, c) -> [o, 0; c, 0]) brackets in
    (* Do work! *)
    _read_input delim ds brackets strings env

end

(* Need to handle string escaping delimiters *)

let rec repl () =
  let string = ReadLine.read ""
              ~prompt:"prompt>"
              ~trim_delim:true
              ~brackets:['(',')'; '{', '}'; '[', ']']
              ~strings:['\''] in
  print_endline @@ string;
  repl ()

let _ = repl ()
