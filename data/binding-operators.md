title: Binding operators (let+, let*)
since: v408
---

```ocaml
let+ data_dir = arg "data_dir"
and+ verbose = flag "v" in
load ~data_dir |> process ~verbose
```
