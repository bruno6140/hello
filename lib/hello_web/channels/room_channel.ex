defmodule HelloWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> lobby, %{"user_id" => username}, socket) do
    socket = assign(socket, :lobby, lobby)
    socket = assign(socket, :username, username)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # Cargar mensajes desde Valkey
    {:ok, messages} = Redix.command(:redix, ["LRANGE", "chat:" <> socket.assigns.lobby, "0", "-1"])

    # Enviar mensajes
    Enum.each(messages, fn msg ->
      {:ok, data} = Jason.decode(msg)
      push(socket, "new_msg", data)
    end)

    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    lobby = socket.assigns.lobby

    # Guardar mensaje en Valkey
    {:ok, _} = Redix.command(:redix, ["RPUSH", "chat:" <> lobby, Jason.encode!(%{user_id: socket.assigns.username, body: body})])

    # Enviar mensaje a todos los del canal
    broadcast!(socket, "new_msg", %{user_id: socket.assigns.username, body: body})

    {:noreply, socket}
  end
end
