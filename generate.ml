(* To be called with resolution as two digits, followed by a Wolfram Code.
Example: ./generate.out 1920 1080 110 *)

open Graphics;;

Random.init (int_of_float (Unix.gettimeofday ()));;

let rec pow = fun i j -> match j with
  | 0 -> 1
  | j -> let a = pow i (j/2) in a*a*(if j mod 2 = 1 then i else 1);;

let size = " " ^ Sys.argv.(1) ^ "x" ^ Sys.argv.(2) ^ "+30-50";;
open_graph size;;

let sx = size_x () and sy = size_y ();;

let color_conv = fun t -> match t with
  | 0 -> rgb 0 255 255
  | 1 -> rgb 255 0 255
  | 2 -> rgb 255 255 0
  | 3 -> rgb 255 255 255
  | 4 -> rgb 255 0 0
  | 5 -> rgb 0 255 0
  | 6 -> rgb 0 0 255
  | _ -> rgb 0 0 0;;

let rec drawline = fun line n i -> match i with
  | i when i >= sx -> ()
  | i -> set_color (color_conv line.(i)); plot i n; drawline line n (i+1);;

let rec generate_automato = fun colors neighborhood rules previous line ->
    if line = sy || key_pressed () then let s = wait_next_event [Key_pressed] in
      if s.key = 'a' then generate_automato colors neighborhood rules previous 0 else () else
    begin
      let newline = Array.make sx 0 in
      for j = 0 to sx - 1 do
        let r = ref 0 in
        for k = -neighborhood to neighborhood do
          r := colors * !r + (if j+k < sx && j+k >= 0 then previous.(j+k) else 0)
        done;
        newline.(j) <- rules.(!r)
      done;
      drawline newline line 0;
      generate_automato colors neighborhood rules newline (line+1)
    end;;

let rec main = fun colors neighborhood code ->
  let initial = Array.make sx 0 and
      rules = pow colors (2*neighborhood+1) in
  let rule = Array.make rules 0 and curcode = ref code in
  for j = 0 to rules - 1 do
    rule.(j) <- !curcode mod colors;
    curcode := !curcode / colors
  done;
  for j = 0 to sx - 1 do
    initial.(j) <- 0(*Random.int colors*)
  done;
  initial.(sx-1)<-1;
  generate_automato colors neighborhood rule initial 0;
  clear_graph ();
  main colors neighborhood code;;

main 2 1 (int_of_string Sys.argv.(3));;
