open StdLabels
open Caniuse

type t = { features : Feature.t list }

let make ~features = { features }

(* Note that this allows injection from md files *)
let unsafe_omd doc = Tyxml_html.Unsafe.data (Omd.to_html doc)

let css =
  {|
:root {
  --base03:   #002b36;
  --base02:   #073642;
  --base01:   #586e75;
  --base00:   #657b83;
  --base0:    #839496;
  --base1:    #93a1a1;
  --base2:    #eee8d5;
  --base3:    #fdf6e3;
  --yellow:   #b58900;
  --orange:   #cb4b16;
  --red:      #dc322f;
  --magenta:  #d33682;
  --violet:   #6c71c4;
  --blue:     #268bd2;
  --cyan:     #2aa198;
  --green:    #859900;
}

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
        border: 1px solid lightgray;
        border-radius:5px;
        padding: 5px;
}

pre {
  background-color: var(--base3);
  padding: 3px;
}

.ocaml-keyword, .ocaml-keyword-other {
  color: var(--base03);
  font-weight: bold;
}

.ocaml-constant-language-capital-identifier {
  color: var(--base02);
}

.ocaml-keyword-operator{
  color: var(--base01);
  font-weight: bold;
}
        |}

let layout content =
  let open Tyxml.Html in
  html
    (head (title (txt "Can I Use? OCaml")) [ style [ txt css ] ])
    (body content)

let index_js =
  {|
(function() {
  const handler = function() {
    const featureFilter = document.querySelector('.filter').value;
    const versionFilter = document.querySelector('.min-version').value;
    document.querySelectorAll('[data-title]').forEach(function(i){
      const title = i.dataset.title;
      const includedInFeatureFilter = title.toLowerCase().includes(featureFilter.toLowerCase());
      const since = +i.dataset.since;
      const includedInVersionFilter = versionFilter === '' || since >= +versionFilter;
      if(includedInFeatureFilter && includedInVersionFilter){
        i.style.display = '';
      } else {
        i.style.display = 'none';
      }
    });
  };
  document.querySelector('.filter').onkeyup = handler;
  document.querySelector('.min-version').onchange = handler;
})()
|}

let index { features } =
  let open Tyxml.Html in
  layout
    [
      h1 [ txt "Can I Use...? (this OCaml feature)" ];
      form
        [
          input ~a:[ a_class [ "filter" ]; a_placeholder "let" ] ();
          select
            ~a:[ a_class [ "min-version" ] ]
            (option ~a:[ a_value "" ] (txt "-- any version")
            :: List.map Version.all ~f:(fun v ->
                   option
                     ~a:[ a_value (string_of_int (Version.to_enum v)) ]
                     (txt (Version.to_string v))));
        ];
      div
        ~a:[ a_class [ "features" ] ]
        (List.map features ~f:(fun feature ->
             let id = Feature.id feature in
             let title = Feature.title feature in
             a
               ~a:
                 [
                   a_href (Printf.sprintf "/feature/%s" id);
                   a_class [ "feature" ];
                   a_user_data "title" title;
                   a_user_data "since"
                     (Feature.since feature |> Version.to_enum |> string_of_int);
                 ]
               ([ h3 [ txt title ] ]
               @
               match Feature.description feature with
               | None -> []
               | Some doc -> [ div [ unsafe_omd doc ] ])));
      script (cdata_script index_js);
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
