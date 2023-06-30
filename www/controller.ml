open StdLabels
open Caniuse

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

let index_js =
  {|
(function() {
  document.querySelector('.filter').onkeyup = function(e) {
    const query = e.target.value;
    document.querySelectorAll('[data-title]').forEach(function(i){
      if(i.dataset.title.includes(query)){
        i.style.display = '';
      } else {
        i.style.display = 'none';
      }
    });
  }
})()
|}

let index { features } =
  let open Tyxml.Html in
  layout
    [
      form [ input ~a:[ a_class [ "filter" ] ] () ];
      ul
        (List.map features ~f:(fun feature ->
             let id = Feature.id feature in
             let title = Feature.title feature in
             li
               ~a:[ a_user_data "title" title ]
               [ link_ ~to_:(Printf.sprintf "/feature/%s" id) [ txt title ] ]));
      script (txt index_js);
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
