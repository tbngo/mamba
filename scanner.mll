(* Ocamllex scanner for Mamba *)

{ open Mambaparse }

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let string = '"' ((([' '-'!' '#'-'[' ']'-'~']) | '\\' ['\\' ''' '"' 'n' 'r' 't'])* as s) '"'

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "#"     { comment lexbuf }           (* Comments *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ';'      { SEMI }
| ':'      { COLON }
(* COMMA *)
| ','      { COMMA }
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '%'      { MODULUS }
| '='      { ASSIGN }
| "=="     { EQ }
| "!="     { NEQ }
| "!"      { NOT }
| '<'      { LT }
| '>'      { GT }
| ">="     { GEQ }
| "<="     { LEQ }
| "and"     { AND }
| "or"     { OR }
| "if"     { IF }
| "else"   { ELSE }
| "while"  { WHILE }
| "def"    { DEF }
| "end"    { END }
(* RETURN *)
| "return" { RETURN }
| "int"    { INT }
| "bool"   { BOOL }
| "str"    { STRING }
| "true"   { BLIT(true)  }
| "false"  { BLIT(false) }
| "empty"  { EMPTY }
| digit+ as lem  { LITERAL(int_of_string lem) }
| letter (digit | letter | '_')* as lem { ID(lem) }
| string    {STRING_LITERAL ((Scanf.sscanf ("\"" ^ s ^ "\"") "%S%!" (fun x -> x)))}
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  '\n' { token lexbuf }
| _    { comment lexbuf }
