open Caniuse

let term =
  let open Cmdliner_let_syntax in
  let open Cmdliner.Arg in
  let+ path = required (opt (some string) None (info [ "data-dir" ])) in
  let features = Load.dir ~path in
  Controller.make ~features |> Controller.routes |> Dream.router |> Dream.logger
  |> Dream.run ~interface:"0.0.0.0"

let info = Cmdliner.Cmd.info "caniuse-server"
let cmd = Cmdliner.Cmd.v info term
let () = Cmdliner.Cmd.eval cmd |> Stdlib.exit
