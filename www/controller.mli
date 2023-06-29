open Caniuse

type t

val make : features:Feature.t list -> t
val routes : t -> Dream.route list
