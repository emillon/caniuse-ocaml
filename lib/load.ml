open StdLabels

let input_lines ic =
  let rec go acc =
    match In_channel.input_line ic with
    | Some l -> go (l :: acc)
    | None -> List.rev acc
  in
  go []

let unlines = String.concat ~sep:"\n"

let parse_yaml_md path =
  let lines = In_channel.with_open_bin path input_lines in
  let rec go acc lines =
    match lines with
    | [] -> Error (`Msg "no separator found")
    | "---" :: rest ->
        let yaml = Yaml.of_string_exn (unlines (List.rev acc)) in
        let md = Omd.of_string (unlines rest) in
        Ok (yaml, md)
    | l :: ls -> go (l :: acc) ls
  in
  let open Result_let_syntax in
  let* yaml, md_raw = go [] lines in
  let+ feature = Feature.of_yaml ~path yaml in
  let md = Hilite.Md.transform md_raw in
  Feature.add_description feature md

let parse_path path =
  match Filename.extension path with
  | ".yml" -> Feature.of_yaml_file ~path
  | ".md" -> parse_yaml_md path
  | ext -> failwith ext

let dir ~path:dir =
  Sys.readdir dir |> Array.to_list
  |> List.map ~f:(fun f ->
         let path = Filename.concat dir f in
         match parse_path path with Ok x -> x | Error (`Msg s) -> failwith s)
