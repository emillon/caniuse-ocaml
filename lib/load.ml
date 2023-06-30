open StdLabels

let yaml ~data_dir =
  Sys.readdir data_dir |> Array.to_list
  |> List.map ~f:(fun f ->
         let path = Filename.concat data_dir f in
         Feature.of_yaml_file ~path)
