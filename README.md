# ocamline

This library provides a simple interface for reading user input
in OCaml programs. The goal of this project is to reduce the
burden of reading user input for programming language REPLs.

The feature that makes this library particularly useful is its handling of
brackets. Any brackets that are opened must be closed before input is accepted.


## Example

#### Source Code:
```ocaml
read ~brackets:['(',')'] ~prompt:"prompt>" ""
```
#### Command Line:
```
prompt> (lambda
          (x)
          (+ x 1))
prompt>
```


# API

```ocaml
val read :  ?trim_delim:bool ->
            ?brackets:(char * char) list ->
            ?prompt:string ->
            ?strings:char list ->
            delim:string ->
            string
```
|Parameter|Description|
|---|---|
|`trim_delim`|Whether or not to remove the line delimiter from the return value.|
|`brackets`| Any characters that once opened must be closed before the line is accepted|
|`prompt`| Customizes the prompt displayed to the user.|
|`strings`| If brackets are in strings, they won't have to be closed.|
|`delim`| The string that, when found, halts scanning and returns the input.|

# Contributions

Contributions to `ocamline` are greatly appreciated! ❤️

Please try to keep its implementation unassuming and configurable. 🙂
