(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Equal | Neq | Less | And | Or | Geq | Leq | Greater | Mult | Div | Mod

type typ = Int | Bool | String | Empty

type opmod = Not

type expr =
    Literal of int
  | BoolLit of bool
  | Id of string
  | StringLit of string
  | Binop of expr * op * expr
  | Assign of string * expr
  | Opmod of opmod * expr
  (* function call *)
  | Call of string * expr list
  | Noexpr

type stmt =
    Block of stmt list
  | Expr of expr
  | If of expr * stmt * stmt
  | While of expr * stmt
  (* return *)
  | Return of expr

(* int x: name binding *)
type bind = typ * string

(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: bind list;
  locals: bind list;
  body: stmt list;
}

type program = bind list * func_def list

(* Pretty-printing functions *)
let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Greater -> ">"
  | Geq -> ">="
  | Leq -> "<="
  | And -> "&&"
  | Or -> "||"

let string_of_opmod = function
    Not -> "!"

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | StringLit(s) -> s
  | Id(s) -> s
  | Binop(e1, o, e2) ->
    string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Opmod(o, e) -> string_of_opmod o ^ string_of_expr e
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""
  and string_of_list = function
      l -> "[" ^ (string_of_seq l) ^ "]"
  and string_of_seq = function
      x :: y :: a -> string_of_expr x ^ ", " ^ string_of_seq (y :: a)
    | x :: _ -> string_of_expr x
    | [] -> ""

let rec string_of_stmt = function
    Block(stmts) ->
    "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n"
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n"
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
                      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_typ = function
    Int -> "int"
  | String -> "str"
  | Bool -> "bool"
  | Empty -> "empty"

let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  "def " ^ string_of_typ fdecl.rtyp ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
