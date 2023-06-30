type t = {
  id : string;
  since : Version.t;
  title : string;
  description : Omd.doc option;
}

let title t = t.title
let id t = t.id
let get_by_id l id = List.find (fun t -> String.equal id t.id) l
let is_included_in { since; _ } v = Version.compare v since >= 0
let versions x = Version.all |> List.filter (is_included_in x)

let matches t ~query =
  let re = Re.(compile (no_case (str query))) in
  Re.exec_opt re t.title |> Option.is_some

let error_msgf = Printf.ksprintf (fun s -> Error (`Msg s))

let of_yaml ~path value =
  let id = Filename.basename path |> Filename.chop_extension in
  let open Result_let_syntax in
  let* title =
    let* value_title = Yaml.Util.find "title" value in
    match value_title with
    | None -> Error (`Msg "No title found")
    | Some s -> Yaml.Util.to_string s
  in
  let+ since =
    let* value_since = Yaml.Util.find "since" value in
    match value_since with
    | None -> error_msgf "%s: no since found" path
    | Some x -> Version.of_yaml x
  in
  { id; title; since; description = None }

let of_yaml_file ~path =
  let open Result_let_syntax in
  let contents = In_channel.with_open_bin path In_channel.input_all in
  let* value = Yaml.of_string contents in
  of_yaml ~path value

let add_description t doc = { t with description = Some doc }
let description t = t.description
let since t = t.since
