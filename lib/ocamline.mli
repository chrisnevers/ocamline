(**
  [read ?trim_delim ?brackets ?prompt ?strings delim] will read input from
  stdin until a new line or [delim] string is encountered. Occurrences of
  [delim] not at the end of the line will not stop the input process.
  If [delim] is an empty string, it will return on new lines.

  [trim_delim]: Whether or not to remove the line delimiter from the return value.

  [brackets]: Any characters that once opened must be closed before the line is accepted.

  [prompt]: Customizes the prompt displayed to the user.

  [strings]: If brackets are in strings, they won't have to be closed.

  [delim]: The string that, when found, halts scanning and returns the input.

  *)
val read :
  ?trim_delim:bool ->
  ?brackets:(char * char) list ->
  ?prompt:string ->
  ?strings:char list ->
  string ->
  string
