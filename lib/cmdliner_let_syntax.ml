open Cmdliner.Term

let ( let+ ) x f = const f $ x
let ( and+ ) x y = const (fun vx vy -> (vx, vy)) $ x $ y
