defmodule SessionController do
  use Docput.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end
