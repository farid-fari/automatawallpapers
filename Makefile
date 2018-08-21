all: generate.out

generate.out: generate.ml
	ocamlopt -I +threads -O3 -o $@ unix.cmxa threads.cmxa graphics.cmxa $<

