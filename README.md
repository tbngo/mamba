### Build the Mamba compiler

```
ocamlbuild -pkgs llvm mamba.native
```

### Run the Mamba compiler and generate llvm code
```
./mamba.native -l tests/example.mb > tests/example.out
```

### Run the llvm code
```
lli tests/example.out
```
###
```
This is all in a make file. Running make cleans restores the directory. Running make all compiles mamba.native and running make test runs the test code example.mb with mamba.native and prints the output of the llvm file.
```

### Compiler files
-  `ast.ml`: abstract syntax tree (AST) definition
-  `scanner.mll`: scanner
-  `mambaparse.mly`: parser
-  `sast.ml`: definition of the semantically-checked AST
-  `semant.ml`: semantic checking
-  `irgen.ml`: LLVM IR code generator

### Other files

- `test1.ml`: the file to test the scanner and parser
- `test2.ml`: the file to test the semantic checker
- `mamba.ml`: top-level file to test and run microc compiler
- `example.mc`: a sample microc source code
- `example.out`: a sample compiled code of example.mc
