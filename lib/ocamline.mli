val read :
  ?trim_delim:bool ->
  ?brackets:(char * char) list ->
  ?prompt:string ->
  ?strings:char list ->
  string ->
  string

(* Helpers *)

val _ends_with : string -> string -> int -> bool

val _count_char : char -> char list -> char list -> int
