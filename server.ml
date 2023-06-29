let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Index.render ());
         Dream.get "/feature/:id" (fun request ->
             Show.render (Dream.param request "id"));
       ]
