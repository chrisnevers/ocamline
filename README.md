# <p align="center"><img alt="ocamline" src="assets/ocamline.png" width = 45% /></p>

This library provides a simple interface for reading user input
in OCaml programs. The goal of this project is to reduce the
burden of reading user input for programming language REPLs.

The feature that makes this library particularly useful is its handling of
brackets. Any brackets that are opened must be closed before input is accepted.
This library uses [ocaml-linenoise](https://github.com/ocaml-community/ocaml-linenoise) to provide `rlwrap` like functionality, including
command history, arrow navigation, etc.


## Example

#### Source Code:
```ocaml
read ~brackets:['(',')'] ~prompt:"lisp>" ()
```
#### Command Line:
```
lisp> (lambda
          (x)
          (+ x 1))
lisp>
```


# API

```ocaml
val read :  ?trim_delim:bool ->
            ?brackets:(char * char) list ->
            ?prompt:string ->
            ?strings:char list ->
            ?history_loc:string ->
            ?hints_callback:(string -> (string * LNoise.hint_color * bool) option) ->
            ?completion_callback:(string -> LNoise.completions -> unit) ->
            ?delim:string ->
            unit ->
            string
```
|Parameter|Description|Default Value|
|---|---|--|
|`trim_delim`|Whether or not to remove the line delimiter from the return value.|`false`|
|`brackets`| Any characters that once opened must be closed before the line is accepted|`[]`|
|`prompt`| Customizes the prompt displayed to the user.|`">"`|
|`strings`| String delimiters. If brackets are in strings, they won't have to be closed.|`[]`|
|`history_loc`|Where to store the history for the user commands|`".ocamline_history.txt"`|
|`hints_callback`|Linenoise's hints callback. See [here](http://ocaml-community.github.io/ocaml-linenoise/1.3/linenoise/LNoise/index.html#val-set_hints_callback)|No op|
|`completion_callback`|Linenoise's completion callback. See [here](http://ocaml-community.github.io/ocaml-linenoise/1.3/linenoise/LNoise/index.html#val-set_completion_callback)|No op|
|`delim`| The string that, when found, halts scanning and returns the input.|`"" (* newlines *)`|

# Contributions

Contributions to `ocamline` are greatly appreciated! ❤️

Please try to keep its implementation unassuming and configurable. 🙂
