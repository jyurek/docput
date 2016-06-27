defmodule Docput.DocumentsController do
  use Docput.Web, :controller

  alias Docput.Document

  def show(conn, %{"id" => id, "revision" => revision}) do
    document = Repo.get_by!(Document, %{
      "id" => id,
      # "revision" => revision
    })
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Document.changeset(%Document{}, :create))
    |> assign(:current_user, preload_associations(conn.assigns.current_user))
    |> render("new.html")
  end

  def create(conn, %{"document" => document_params}) do
    document_params = document_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Document.changeset(%Document{}, :create, document_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        redirect(conn, to: documents_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> assign(:current_user, preload_associations(conn.assigns.current_user))
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    document = Repo.get!(Document, id)
    conn
    |> assign(:changeset, Document.changeset(document, :update))
    |> assign(:current_user, preload_associations(conn.assigns.current_user))
    |> assign(:document, Repo.get!(Document, id))
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Repo.get!(Document, id)
    document_params = document_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Document.changeset(document, :update, document_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        redirect(conn, to: documents_path(conn, :index))
      {:error, _changeset} ->
        render(conn, "new.html", %{
          changeset: changeset
        })
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Repo.get_by!(Document, id: id, user_id: conn.assigns.current_user.id)
    case Repo.delete(document) do
      {:ok, document} ->
        conn
        |> put_flash(:notice, "Removed!")
        |> redirect(to: documents_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to remove that document.")
        |> redirect(to: documents_path(conn, :index))
    end
  end

  defp preload_associations(user) do
    Repo.preload(user, [:documents, :layouts])
  end
end
