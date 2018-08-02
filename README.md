# Automata wallpapers

A slick wallpaper generator, that works with interesting cellular automata and random initial conditions to generate unique wallpapers.

Use the [Wolfram atlas](http://atlas.wolfram.com/01/01/) to find interesting Wolfram codes.

## Examples

![example](examples/three.png?raw=true)

![example](examples/four.png?raw=true)

## Usage

    ./generate.out 1920 1080 110

The first two digits are the frame width then height of the image to generate.

The third digit is the Wolfram Code for the automata.
The initial line is random.

Several settings can be altered in `generate.ml` in order to change the way the code is processed, for instance the color palette.

| Key | Action|
| --- | --- |
| `+` | Increase code by `1` and regenerate |
| `-` | Decrease code by `1` and regenerate |
| `r` | Regenerate with a random code (between 0 and 2³⁰) |
| `space` | Regenerate with a new initial line |
| `q` | Exit |

The other keys have no effect.
