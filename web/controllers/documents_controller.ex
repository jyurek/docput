defmodule Docput.DocumentsController do
  use Docput.Web, :controller

  alias Docput.Document
  alias Docput.Revision
  alias Docput.DocPutter

  def new(conn, _params) do
    conn
    |> assign(:changeset, Document.changeset(%Document{}))
    |> assign(:current_user, preload_associations(conn.assigns.current_user))
    |> render("new.html")
  end

  def create(conn, %{"document" => document_params}) do
    document_params = document_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    DocPutter.create(document_params)

    redirect(conn, to: home_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    document = Repo.get_by!(Document, id: id, user_id: conn.assigns.current_user.id)
    case Repo.delete(document) do
      {:ok, document} ->
        conn
        |> put_flash(:notice, "Removed!")
        |> redirect(to: home_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to remove that document.")
        |> redirect(to: home_path(conn, :index))
    end
  end


  defp preload_associations(user) do
    Repo.preload(user, [:documents, :layouts])
  end
end
