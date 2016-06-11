defmodule Docput.HomeController do
  use Docput.Web, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      conn
      |> assign(:current_user, preload_associations(conn.assigns.current_user))
      |> render("index.html")
    else
      conn |> render("guest.html")
    end
  end

  defp preload_associations(user) do
    Repo.preload(user, [:documents, :templates])
  end
end
