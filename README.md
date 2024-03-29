# Automata wallpapers

A slick wallpaper generator, that works with interesting cellular automata and random initial conditions to generate unique wallpapers.

Use the [Wolfram atlas](http://atlas.wolfram.com/01/01/) to find interesting Wolfram codes.

## Examples

![example1](examples/one.png?raw=true)

![example2](examples/two.png?raw=true)

![example3](examples/three.png?raw=true)

![example4](examples/four.png?raw=true)

![example5](examples/five.png?raw=true)

## Usage

    ./generate.out 1920 1080 110

The first two integers are the frame width then height of the image to generate.

The third integer is the Wolfram Code for the automata.

The initial line is random, and the color palette is chosen randomly at each draw.

Several settings can be altered in `generate.ml` in order to change the way the code is processed, the number of colors used and the size of the neighborhood considered.

| Key | Action|
| --- | --- |
| `+` | Increase code by `1` and regenerate |
| `-` | Decrease code by `1` and regenerate |
| `r` | Regenerate with a random rule |
| `p` | Change color palettes randomly mid-draw |
| `space` | Regenerate with a new initial line |
| `q` | Exit |

The other keys have no effect.

## Building

The file `generate.out` is a binary compiled for linux and OSX using architecture `x64`.

The `Makefile` defines a rule for that executable but requires `ocamlopt` with
`Flambda` optimizations to be installed, as well as the `graphics` package if
you're using a version of OCaml newer than 4.08.
You can install those using `opam` inside a switch.

You can also use `ocamlc` by replacing `graphics.cmxa` by `graphics.cma`.
