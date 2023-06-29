let ( let+ ) x f =
  let open Cmdliner.Term in
  const f $ x
