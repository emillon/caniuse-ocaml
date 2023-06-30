open StdLabels

let yaml ~data_dir =
  Sys.readdir data_dir |> Array.to_list
  |> List.map ~f:(fun f ->
         let path = Filename.concat data_dir f in
         match Feature.of_yaml_file ~path with
         | Ok x -> x
         | Error (`Msg s) -> failwith s)
