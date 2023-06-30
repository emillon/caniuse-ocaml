type t = {
  id : string;
  since : Version.t option;
  until : Version.t option;
  title : string;
}

let title t = t.title
let id t = t.id
let get_by_id l id = List.find (fun t -> String.equal id t.id) l

let is_included_in { since; until; _ } v =
  let since_ok =
    match since with None -> true | Some since -> Version.compare v since >= 0
  in
  let until_ok =
    match until with None -> true | Some until -> Version.compare v until < 0
  in
  since_ok && until_ok

let versions x = Version.all |> List.filter (is_included_in x)

let matches t ~query =
  let re = Re.(compile (no_case (str query))) in
  Re.exec_opt re t.title |> Option.is_some

let of_yaml_file ~path =
  let contents = In_channel.with_open_bin path In_channel.input_all in
  let id = Filename.basename path |> Filename.chop_extension in
  let value = Yaml.of_string_exn contents in
  let title =
    value |> Yaml.Util.find_exn "title" |> Option.get |> Yaml.Util.to_string_exn
  in
  let since =
    value |> Yaml.Util.find_exn "since" |> Option.get |> Version.of_yaml
  in
  { id; title; since = Some since; until = None }
