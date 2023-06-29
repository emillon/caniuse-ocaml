type t = {
  id : string;
  since : Version.t option;
  until : Version.t option;
  title : string;
}

let title t = t.title
let id t = t.id

let all =
  [
    {
      id = "Set.Disjoint";
      title = "Set.disjoint";
      since = Some V_408;
      until = None;
    };
    {
      id = "Map.filter_map";
      title = "Map.filter_map";
      since = Some V_411;
      until = None;
    };
  ]

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
