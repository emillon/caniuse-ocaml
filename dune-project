(lang dune 3.0)

(source
 (github emillon/caniuse-ocaml))

(maintainers "Etienne Millon")

(authors "Etienne Millon")

(generate_opam_files)

(name caniuse)

(package
 (name caniuse)
 (synopsis "Determine which OCaml version support which feature")
 (depends
  (ocaml
   (>= 4.14))
  dream
  tyxml
  ppx_deriving
  re
  cmdliner
  yaml
  omd))

