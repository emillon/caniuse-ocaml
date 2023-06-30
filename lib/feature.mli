type t

val title : t -> string
val get_by_id : t list -> string -> t
val id : t -> string
val versions : t -> Version.t list
val matches : t -> query:string -> bool
val of_yaml_file : path:string -> t
