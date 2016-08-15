defmodule Docput.HomeController do
  use Docput.Web, :controller
  alias Docput.Revision

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
    Repo.preload(
      user,
      [
        :layouts,
        :assets,
        documents:
          [revisions: from(r in Revision, order_by: r.inserted_at)]
      ]
    )
  end
end
