
let rec repl () =
  let string = ReadLine.read ""
              ~prompt:"prompt>"
              ~trim_delim:true
              ~brackets:['(',')'; '{', '}'; '[', ']']
              ~strings:['"'] in
  print_endline @@ string;
  repl ()

let _ = repl ()
