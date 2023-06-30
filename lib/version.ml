type t =
  | V_402
  | V_403
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
    V_402;
    V_403;
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
  | V_402 -> "4.02"
  | V_403 -> "4.03"
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

let of_yaml v =
  let open Result_let_syntax in
  let* s = Yaml.Util.to_string v in
  match s with
  | "v402" -> Ok V_402
  | "v403" -> Ok V_402
  | "v404" -> Ok V_404
  | "v405" -> Ok V_405
  | "v406" -> Ok V_406
  | "v407" -> Ok V_407
  | "v408" -> Ok V_408
  | "v409" -> Ok V_409
  | "v410" -> Ok V_410
  | "v411" -> Ok V_411
  | "v412" -> Ok V_412
  | "v413" -> Ok V_413
  | "v414" -> Ok V_414
  | "v50" -> Ok V_50
  | _ -> Printf.ksprintf (fun s -> Error (`Msg s)) "unknown version %S" s
