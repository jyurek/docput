defmodule Docput.TemplatesController do
  use Docput.Web, :controller
  alias Docput.Template
  alias Phoenix.Controller.Flash

  require Logger

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
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    template = Repo.get!(Template, id)
    conn
    |> assign(:changeset, Template.changeset(template, :update))
    |> assign(:template, Repo.get!(Template, id))
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Repo.get!(Template, id)
    template_params = template_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Template.changeset(template, :update, template_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> redirect(to: documents_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> assign(:template, Repo.get!(Template, id))
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Repo.get_by!(Template, id: id, user_id: conn.assigns.current_user.id)
    case Repo.delete(template) do
      {:ok, template} ->
        conn
        |> put_flash(:notice, "Removed!")
        |> redirect to: documents_path(conn, :index)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to remove that template.")
        |> redirect to: documents_path(conn, :index)
    end
  end
end
