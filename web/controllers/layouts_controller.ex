defmodule Docput.LayoutsController do
  use Docput.Web, :controller
  alias Docput.Layout
  alias Phoenix.Controller.Flash

  require Logger

  def new(conn, _params) do
    conn
    |> assign(:changeset, Layout.changeset(%Layout{}, :create))
    |> render "new.html"
  end

  def create(conn, %{"layout" => layout_params}) do
    layout_params = layout_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Layout.changeset(%Layout{}, :create, layout_params)
    case Repo.insert(changeset) do
      {:ok, _layout} ->
        redirect(conn, to: documents_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    layout = Repo.get!(Layout, id)
    conn
    |> assign(:changeset, Layout.changeset(layout, :update))
    |> assign(:layout, Repo.get!(Layout, id))
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "layout" => layout_params}) do
    layout = Repo.get!(Layout, id)
    layout_params = layout_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Layout.changeset(layout, :update, layout_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> redirect(to: documents_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> assign(:layout, Repo.get!(Layout, id))
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    layout = Repo.get_by!(Layout, id: id, user_id: conn.assigns.current_user.id)
    case Repo.delete(layout) do
      {:ok, layout} ->
        conn
        |> put_flash(:notice, "Removed!")
        |> redirect to: documents_path(conn, :index)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to remove that layout.")
        |> redirect to: documents_path(conn, :index)
    end
  end
end
