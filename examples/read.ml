open Ocamline

let hints = function
  | "git remote add " -> Some (" <remote name> <remote url>", LNoise.Yellow, true)
  | _ -> None

let completion line_so_far ln_completions =
  if line_so_far <> "" && line_so_far.[0] = 'h' then
    ["Hey"; "Howard"; "Hughes"; "Hocus"] |> List.iter (LNoise.add_completion ln_completions)

let rec repl () =
  let str = read
    ~prompt:"ocamline>"
    ~brackets:['(', ')']
    ~delim:";;"
    ~hints_callback:hints
    ~completion_callback:completion
    ()
  in
  print_endline str;
  repl ()

let _ = repl ()
