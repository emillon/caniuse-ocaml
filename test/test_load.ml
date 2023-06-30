open Caniuse

let main ~path =
  let (_ : Feature.t list) = Load.dir ~path in
  ()

let () = match Sys.argv with [| _; path |] -> main ~path | _ -> assert false
