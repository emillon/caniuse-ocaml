title: type nonrec
since: v402
---

```ocaml
type t = A
module Collection = struct
  type nonrec t = t list
end
```
