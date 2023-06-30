let ( let* ) x f = Result.bind x f
let ( let+ ) x f = Result.map f x
