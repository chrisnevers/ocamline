open Ocamline

let rec repl () =
  let str = read
    ~prompt:"ocamline>"
    ~brackets:['(', ')']
    ~delim:";;"
    ()
  in
  print_endline str;
  repl ()

let _ = repl ()
