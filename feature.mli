type t

val title : t -> string
val all : t list
val get_by_id : string -> t
val id : t -> string
val versions : t -> Version.t list
