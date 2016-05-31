defmodule SessionController do
  use Docput.Web, :controller

  def new(conn, _params) do
    render "new.html"
  end
end
