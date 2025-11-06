defmodule HelloWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> _lobby_name, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body, "user_id" => user_id}, socket) do
    broadcast!(socket, "new_msg", %{body: body, user_id: user_id})
    {:noreply, socket}
  end
end
