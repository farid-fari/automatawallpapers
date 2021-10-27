all: generate.out

generate.out: generate.ml
	ocamlfind ocamlopt -O3 -o $@ -package graphics -linkpkg $<

