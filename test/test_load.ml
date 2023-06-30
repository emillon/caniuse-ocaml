open Caniuse

let main data_dir =
  let (_ : Feature.t list) = Load.yaml ~data_dir in
  ()

let () =
  match Sys.argv with [| _; data_dir |] -> main data_dir | _ -> assert false
