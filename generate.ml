open Graphics;;

Random.self_init ();;

(* Quick exponentiation. *)
let rec pow = fun i j -> match j with
    | 0 -> 1
    | j -> let a = pow i (j/2) in a*a*(if j mod 2 = 1 then i else 1);;

(* Initiliazing graphics. *)
let size = " " ^ Sys.argv.(1) ^ "x" ^ Sys.argv.(2) ^ "+30-50";;
open_graph size;;

let sx = size_x () and sy = size_y ();;

(* Use this to configure the color palettes.
These are configured for four colors (plus placeholder color).
Feel free to add or remove some. *)
let palettes = [| (function
    | 0 -> rgb 247 240 82
    | 1 -> rgb 242 129 35
    | 2 -> rgb 211 78 36
    | 3 -> rgb 86 63 27
    | _ -> rgb 0 0 0);
(function
| 0 -> rgb 247 255 252
| 1 -> rgb 227 253 226
| 2 -> rgb 197 241 213
| 3 -> rgb 162 186 164
| _ -> rgb 0 0 0);
(function
| 0 -> rgb 198 249 31
| 1 -> rgb 20 17 21
| 2 -> rgb 76 43 54
| 3 -> rgb 141 99 70
| _ -> rgb 0 0 0);
(function
| 0 -> rgb 238 243 106
| 1 -> rgb 63 48 71
| 2 -> rgb 81 113 165
| 3 -> rgb 155 201 149
| _ -> rgb 0 0 0);
 (function
| 0 -> rgb 75 144 168
| 1 -> rgb 74 185 211
| 2 -> rgb 230 89 88
| 3 -> rgb 244 215 75
| _ -> rgb 0 0 0);
(function
| 0 -> rgb 110 37 148
| 1 -> rgb 236 212 68
| 2 -> rgb 0 0 0
| 3 -> rgb 255 255 255
| _ -> rgb 0 0 0); |];;


(* Calculates and draws a line of pixels from the previous line. *)
let rec drawline = fun palette line n i -> match i with
	| i when i >= sx -> ()
	| i -> set_color (palettes.(palette) line.(i)); plot i n; drawline palette line n (i+1);;

(* Generates a new line from the previous one, then launches draw loop. *)
let rec generate_automato = fun code palette colors neighborhood rules previous line ->
    if line = sy || key_pressed () then let s = wait_next_event [Key_pressed] in
      (match s.key with
        | '+' -> main colors neighborhood (max 0 (code+1))
        | '-' -> main colors neighborhood (max 0 (code-1))
        | 'r' -> randomRule colors neighborhood
        | ' ' -> main colors neighborhood code
        | 'p' -> generate_automato code (Random.int (Array.length palettes)) colors neighborhood rules previous line
        | 'q' -> exit 0
        | _ -> generate_automato code palette colors neighborhood rules previous line (* pretend nothing happened *)
      )
    else begin
    let newline = Array.make sx 0 in
    for j = 0 to sx - 1 do
	let r = ref 0 in
	for k = -neighborhood to neighborhood do
		r := colors * !r + (if j+k < sx && j+k >= 0 then previous.(j+k) else 0)
	done;
	newline.(j) <- rules.(!r)
    done;
    drawline palette newline line 0;
    generate_automato code palette colors neighborhood rules newline (line+1)
    end
and
(* Takes the number of colors to be used as well as the radius of neighborhoods
   to be considered (added to the pixel above) and a Wolfram code to begin drawing of an automata.
   Note that specifying a radius different from 1 or an amount of colors other than 2 will make
   your code to be considered differently from Wolfram codes. *)
main = fun colors neighborhood code ->
    let initial = Array.make sx 0 and
        rules = pow colors (2*neighborhood+1) in
    let rule = Array.make rules 0 and curcode = ref (max 0 code) in
    for j = 0 to rules - 1 do
        rule.(j) <- !curcode mod colors;
        curcode := !curcode / colors
    done;
    for j = 0 to sx - 1 do
        initial.(j) <- Random.int colors
    done;
    clear_graph ();
    let palette = Random.int (Array.length palettes) in
    Printf.printf "Format: %sx%s; code: %d; palette: %d\n%!" Sys.argv.(1) Sys.argv.(2) code palette;
    generate_automato code palette colors neighborhood rule initial 0
(* Same but with random rules (and NOT a random code). *)
and randomRule = fun colors neighborhood ->
    let initial = Array.make sx 0 and
        rules = pow colors (2*neighborhood+1) in
    let rule = Array.make rules 0 in
    for j = 0 to rules - 1 do
        rule.(j) <- Random.int colors;
    done;
    for j = 0 to sx - 1 do
        initial.(j) <- Random.int colors
    done;
    clear_graph ();
    let palette = Random.int (Array.length palettes) in
    Printf.printf "Format: %sx%s; random rule; palette: %d\n%!" Sys.argv.(1) Sys.argv.(2) palette;
    generate_automato 0 palette colors neighborhood rule initial 0
in main 4 1 (int_of_string Sys.argv.(3));;
