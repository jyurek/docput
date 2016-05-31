defmodule Docput.PageController do
  use Docput.Web, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      conn |> redirect(to: documents_path(conn, :index))
    else
      conn |> render "index.html"
    end
  end
end
