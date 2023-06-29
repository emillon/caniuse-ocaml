type 'a t := 'a Cmdliner.Term.t

val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
