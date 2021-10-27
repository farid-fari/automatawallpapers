%PHONY: all clean
all: generate.exe

generate.exe: generate.ml
	ocamlopt -O3 -o $@ graphics.cmxa $<

clean:
	rm -f generate.{cm{i,o,x},exe,o}
