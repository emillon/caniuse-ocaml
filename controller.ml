open StdLabels

type t = { features : Feature.t list }

let make ~features = { features }

let layout content =
  let open Tyxml.Html in
  html (head (title (txt "Can I Use? OCaml")) []) (body content)

let list ~f l =
  let open Tyxml.Html in
  ul (List.map ~f:(fun x -> li (f x)) l)

let link_ ~to_ c =
  let open Tyxml.Html in
  a ~a:[ a_href to_ ] c

let index { features } =
  let open Tyxml.Html in
  layout
    [
      list features ~f:(fun feature ->
          [
            link_
              ~to_:(Printf.sprintf "/feature/%s" (Feature.id feature))
              [ txt (Feature.title feature) ];
          ]);
    ]

let show feature =
  let open Tyxml.Html in
  layout
    [
      txt (Feature.title feature);
      txt "Available in versions:";
      list (Feature.versions feature) ~f:(fun v ->
          [ txt (Version.to_string v) ]);
    ]

let dream_tyxml = Format.kasprintf Dream.html "%a" (Tyxml.Html.pp ())

let routes t =
  [
    Dream.get "/" (fun _ -> index t |> dream_tyxml);
    Dream.get "/feature/:id" (fun request ->
        Dream.param request "id"
        |> Feature.get_by_id t.features
        |> show |> dream_tyxml);
  ]
