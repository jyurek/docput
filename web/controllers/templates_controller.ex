defmodule Docput.TemplatesController do
  use Docput.Web, :controller
  alias Docput.Template

  def new(conn, _params) do
    conn
    |> assign(:changeset, Template.changeset(%Template{}, :create))
    |> render "new.html"
  end

  def create(conn, %{"template" => template_params}) do
    template_params = template_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Template.changeset(%Template{}, :create, template_params)
    case Repo.insert(changeset) do
      {:ok, _template} ->
        redirect(conn, to: documents_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", %{
          changeset: changeset
        })
    end
  end
end
