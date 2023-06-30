open Caniuse
open StdLabels

let info = Cmdliner.Cmd.info "caniuse"

let display_feature f =
  Printf.printf "%s\n\nAvailable in versions:\n" (Feature.title f);
  List.iter (Feature.versions f) ~f:(fun v ->
      Printf.printf "  - %s\n" (Version.to_string v))

let term =
  let open Cmdliner_let_syntax in
  let open Cmdliner.Arg in
  let+ query = required (pos 0 (some string) None (info []))
  and+ path = required (opt (some string) None (info [ "data-dir" ])) in
  Load.dir ~path
  |> List.filter ~f:(Feature.matches ~query)
  |> List.iter ~f:display_feature

let cmd = Cmdliner.Cmd.v info term
let () = Cmdliner.Cmd.eval cmd |> Stdlib.exit
