# ocamline

This library provides a simple interface for reading user input
in OCaml programs. The goal of this project is to reduce the
burden of reading user input for programming language REPLs.

There are options available to customize the user prompt.


## Example
`[Source.ml]`
```ocaml
read ~brackets:['{','}'] ~prompt:"prompt>" ""
```
`[Command Line]`
```
prompt> let record = {
          x = 5;
          y = 10;
        }
prompt>
```


## API

```ocaml
val read :  ?trim_delim:bool ->
            ?brackets:(char * char) list ->
            ?prompt:string ->
            ?strings:char list ->
            string ->
            string
```
`trim_delim`: Whether or not to remove the line delimiter from the
return value.

`brackets`: Any characters that once opened must be closed before the line is
accepted.

`prompt`: Customizes the prompt displayed to the user.

`strings`: WIP. If brackets are in strings, they won't have to be closed.
