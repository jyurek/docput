defmodule Docput.DocumentsController do
  use Docput.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:current_user, preload_documents(conn.assigns.current_user))
    |> render("index.html")
  end

  defp preload_documents(user), do: Repo.preload(user, :documents)
end
