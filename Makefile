all: generate.out

generate.out: generate.ml
	ocamlopt -O3 -o $@ graphics.cmxa $<

