type t = { features : Feature.t list }

let make ~features = {features}

let index { features } =
  <html>
  <ul>
% features |> List.iter begin fun feature ->
        <li>
        <a href="/feature/<%s Feature.id feature %>">
          <%s Feature.title feature %>
        </a>
        </li>
% end;
  </ul>
  </html>

let show feature =
        <html>
        <%s Feature.title feature %>
        Available in versions:
        <ul>
% Feature.versions feature |> List.iter begin fun v ->
          <li>
             <%s Version.to_string v %>
          </li>
% end;
        </ul>
        </html>


let routes t =
  [
    Dream.get "/" (fun _ -> index t |> Dream.html);
    Dream.get "/feature/:id" (fun request ->
      Dream.param request "id" |>
      Feature.get_by_id t.features |> show |> Dream.html);
  ]
