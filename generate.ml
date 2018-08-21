open Graphics;;

Random.self_init ();;

(* Quick exponentiation. *)
let rec pow = fun i j -> match j with
    | 0 -> 1
    | j -> let a = pow i (j/2) in a*a*(if j mod 2 = 1 then i else 1);;

(* Maximum number of threads. *)
let chunk_size = int_of_string Sys.argv.(4);;

(* Initiliazing graphics. *)
let size = " " ^ Sys.argv.(1) ^ "x" ^ Sys.argv.(2) ^ "+30-50";;
open_graph size;;

let sx = size_x () and sy = size_y ();;

(* Use this to configure the color palette. *)
let color_conv = fun t -> match t with
    | 0 -> rgb 247 240 82
    | 1 -> rgb 242 129 35
    | 2 -> rgb 211 78 36
    | 3 -> rgb 86 63 27
    | 4 -> rgb 56 114 108
    | 5 -> rgb 0 255 0
    | 6 -> rgb 0 0 255
    | _ -> rgb 0 0 0;;

(* Calculates and draws a chunk of pixels from the previous line. *)
let rec drawpixel = fun colors rules previous neighborhood newline m n (i,j) ->
    for k = i to j-1 do
        let r = ref 0 in
        for l = -neighborhood to neighborhood do
	    r := colors * !r + (if k+l < sx && k+l >= 0 then previous.(k+l) else 0)
        done;
        newline.(k) <- rules.(!r);
	Mutex.lock m;
        set_color (color_conv (rules.(!r))); plot k n;
	Mutex.unlock m;
    done;;

(* Generates a new line from the previous one, then launches draw loop. *)
let rec generate_automato = fun code colors neighborhood rules previous line ->
    if line = sy || key_pressed () then let s = wait_next_event [Key_pressed] in
      (match s.key with
        | '+' -> main colors neighborhood (max 0 (code+1))
        | '-' -> main colors neighborhood (max 0 (code-1))
        | 'r' -> randomRule colors neighborhood
        | ' ' -> main colors neighborhood code
        | 'q' -> exit 0
        | _ -> generate_automato code colors neighborhood rules previous line (* pretend nothing happened *)
      )
    else begin
	let m = Mutex.create ()
        and newline = Array.make sx 0 in
	let f = drawpixel colors rules previous neighborhood newline m line in
        for j = 0 to sx/chunk_size do
		let t = Thread.create f (j*chunk_size, min sx ((j+1)*chunk_size)) in ();
        done;
	Mutex.lock m;
	Mutex.unlock m;
        generate_automato code colors neighborhood rules newline (line+1)
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
    print_endline ("Format: " ^ Sys.argv.(1) ^ "x" ^ Sys.argv.(2) ^ "; Code: " ^ (string_of_int code));
    generate_automato code colors neighborhood rule initial 0
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
    print_endline ("Format: " ^ Sys.argv.(1) ^ "x" ^ Sys.argv.(2) ^ "; Random rule");
    generate_automato 0 colors neighborhood rule initial 0
in main 2 1 (int_of_string Sys.argv.(3));;
