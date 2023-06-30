title: Empty variant types
since: v407
---

```ocaml
type t = |

let absurd (x:t) = match t with
| _ -> .
```
