.PHONY: all
all: mamba.native

.PHONY: clean
clean:
	ocamlbuild -clean
	rm -r example.out

.PHONY: test
test: mamba.native
	./mamba.native -l example.mb > example.out
	lli example.out

mamba.native:
	ocamlbuild -pkgs llvm mamba.native
