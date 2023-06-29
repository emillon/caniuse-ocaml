let template features =
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

let render () =
  Dream.html (template Feature.all)
