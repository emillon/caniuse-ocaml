open StdLabels
open Caniuse

type t = { features : Feature.t list }

let make ~features = { features }

(* Note that this allows injection from md files *)
let unsafe_omd doc = Tyxml_html.Unsafe.data (Omd.to_html doc)

let css =
  {|


a:link, a:visited {
        text-decoration: none;
        color: currentcolor;
}

a:link h3, a:visited h3 {
        text-decoration: underline orange 2px;
        color: currentcolor;
}

body {
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
  font-family: sans-serif;
}

.filter {
  margin-bottom: 20px;
}

.version {
  padding:1px;
  display:inline-block;
  margin-right: 10px;
}

.features {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
}

.feature {
        border: 1px solid gray;
        border-radius:5px;
        padding: 5px;
}
        |}

let layout content =
  let open Tyxml.Html in
  html
    (head (title (txt "Can I Use? OCaml")) [ style [ txt css ] ])
    (body content)

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
      h1 [ txt "Can I Use...? (this OCaml feature)" ];
      form [ input ~a:[ a_class [ "filter" ]; a_placeholder "let" ] () ];
      div
        ~a:[ a_class [ "features" ] ]
        (List.map features ~f:(fun feature ->
             let id = Feature.id feature in
             let title = Feature.title feature in
             link_
               ~to_:(Printf.sprintf "/feature/%s" id)
               [
                 div
                   ~a:[ a_class [ "feature" ]; a_user_data "title" title ]
                   ([ h3 [ txt title ] ]
                   @
                   match Feature.description feature with
                   | None -> []
                   | Some doc -> [ div [ unsafe_omd doc ] ]);
               ]));
      script (txt index_js);
    ]

let show feature =
  let open Tyxml.Html in
  layout
    ([
       h1 [ txt (Feature.title feature) ];
       txt "Available in versions:";
       ul
         (List.map (Feature.versions feature) ~f:(fun v ->
              li ~a:[ a_class [ "version" ] ] [ txt (Version.to_string v) ]));
     ]
    @
    match Feature.description feature with
    | None -> []
    | Some doc -> [ unsafe_omd doc ])

let dream_tyxml = Format.kasprintf Dream.html "%a" (Tyxml.Html.pp ())

let routes t =
  [
    Dream.get "/" (fun _ -> index t |> dream_tyxml);
    Dream.get "/feature/:id" (fun request ->
        Dream.param request "id"
        |> Feature.get_by_id t.features
        |> show |> dream_tyxml);
  ]
