open Alcotest
open Ocamline

let ends_with_test () =
  (check bool) "ends_with" true @@ _ends_with "chris" "is" 2;
  (check bool) "ends_with" false @@ _ends_with "chris" ";" 1

let count_char_test () =
  (check int) "count_char" 0 @@ _count_char '(' ['"'] ['c'; 'h'];
  (check int) "count_char" 1 @@ _count_char '(' ['"'] ['('; 'h'];
  (check int) "count_char" 0 @@ _count_char '(' ['"'] ['"'; '('; '"'];
  (check int) "count_char" 0 @@ _count_char '(' ['"'] ['"'; '\\'; '"'; '('; '"']

let tests = [
  "ends_with",  `Quick, ends_with_test;
  "count_char", `Quick, count_char_test;
]
