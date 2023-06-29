let () =
  Controller.make ~features:Feature.all
  |> Controller.routes |> Dream.router |> Dream.logger
  |> Dream.run ~interface:"0.0.0.0"
