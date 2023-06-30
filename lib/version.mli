type t [@@deriving ord, enum]

val all : t list
val to_string : t -> string
val of_yaml : Yaml.value -> t Yaml.res
