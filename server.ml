let () =
  Controller.make ~features:Feature.all
  |> Controller.routes |> Dream.router |> Dream.logger |> Dream.run
