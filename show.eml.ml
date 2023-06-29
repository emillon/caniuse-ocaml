let template feature =
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

let render id =
  Feature.get_by_id id |> template |> Dream.html
