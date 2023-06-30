type t =
  | V_404
  | V_405
  | V_406
  | V_407
  | V_408
  | V_409
  | V_410
  | V_411
  | V_412
  | V_413
  | V_414
  | V_50
[@@deriving ord]

let all =
  [
    V_404;
    V_405;
    V_406;
    V_407;
    V_408;
    V_409;
    V_410;
    V_411;
    V_412;
    V_413;
    V_414;
    V_50;
  ]

let to_string = function
  | V_404 -> "4.04"
  | V_405 -> "4.05"
  | V_406 -> "4.06"
  | V_407 -> "4.07"
  | V_408 -> "4.08"
  | V_409 -> "4.09"
  | V_410 -> "4.10"
  | V_411 -> "4.11"
  | V_412 -> "4.12"
  | V_413 -> "4.13"
  | V_414 -> "4.14"
  | V_50 -> "5.0"

let of_yaml_string = function
  | "v404" -> V_404
  | "v405" -> V_405
  | "v406" -> V_406
  | "v407" -> V_407
  | "v408" -> V_408
  | "v409" -> V_409
  | "v410" -> V_410
  | "v411" -> V_411
  | "v412" -> V_412
  | "v413" -> V_413
  | "v414" -> V_414
  | "v50" -> V_50
  | s -> Printf.ksprintf invalid_arg "Version.of_yaml_string: %S" s

let of_yaml v = v |> Yaml.Util.to_string_exn |> of_yaml_string
