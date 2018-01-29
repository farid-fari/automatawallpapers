(* To be called with size as two digits.
Example: ./generate.out 1920 1080 *)

open Graphics;;

Random.init (int_of_float (Unix.gettimeofday ()));;

(* Unneeded for now.
let rec pow = fun i j -> match j with
  | 0 -> 1
  | j -> let a = pow i (j/2) in a*a*(if j mod 2 = 1 then j else 1);; *)

let size = " " ^ Sys.argv.(1) ^ "x" ^ Sys.argv.(2) ^ "+50-50";;
open_graph size;;

let sx = size_x () and sy = size_y ();;

let color_conv = fun t -> match t with
  | 0 -> rgb 0 255 255
  | 1 -> rgb 255 0 255
  | 2 -> rgb 255 255 0;;

let rec drawline = fun line n i -> match i with
  | i when i >= sx -> ()
  | i -> set_color (color_conv line.(i)); plot i n; drawline line n (i+1);;

let rec generate_automato = fun colors rules previous line ->
    if line = sy then let _ = wait_next_event [Button_down] in () else begin
      let newline = Array.make (Array.length previous) 0 in
      for j = 1 to sx - 2 do
        let r = colors * colors * previous.(j-1) + colors * previous.(j) + previous.(j+1) in
        newline.(j) <- rules.(r)
      done;
      newline.(0) <- rules.(colors*previous.(0) + previous.(1));
      newline.(sx-1) <- rules.(colors*colors*previous.(sx-2) + colors*previous.(sx-1));
      drawline newline line 0;
      generate_automato colors rules newline (line+1)
    end;;

let main = fun colors ->
  let initial = Array.make sx 0 and
      rules = colors * colors * colors in
  let rule = Array.make rules 0 in
  for j = 0 to rules - 1 do
    rule.(j) <- Random.int colors
  done;
  for j = 0 to sx - 1 do
    initial.(j) <- Random.int colors
  done;
  generate_automato colors rule initial 0;;

main 3;;
