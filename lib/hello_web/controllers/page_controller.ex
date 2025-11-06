defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  def choose(conn, _params) do
    render(conn, :choose)
  end

  def chat(conn, _params) do
    render(conn, :chat)
  end
end
