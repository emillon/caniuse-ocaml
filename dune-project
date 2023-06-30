(lang dune 3.0)

(generate_opam_files)

(name caniuse)

(package
 (name caniuse)
 (depends
  (ocaml
   (>= 4.14))
  dream
  tyxml
  ppx_deriving
  re
  cmdliner
  yaml))
