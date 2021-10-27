%PHONY: all clean
all: generate.exe

generate.exe: generate.ml
	ocamlfind ocamlopt -O3 -o $@ -package graphics -linkpkg $<

clean:
	rm -f generate.{cm{i,o,x},exe,o}
