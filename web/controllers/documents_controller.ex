defmodule Docput.DocumentsController do
  use Docput.Web, :controller

  alias Docput.Document

  def index(conn, _params) do
    conn
    |> assign(:current_user, preload_associations(conn.assigns.current_user))
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Document.changeset(%Document{}, :create))
    |> assign(:current_user, preload_associations(conn.assigns.current_user))
    |> render("new.html")
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

  def create(conn, %{"document" => document_params}) do
    document_params = document_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    changeset = Document.changeset(%Document{}, :create, document_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        redirect(conn, to: documents_path(conn, :index))
      {:error, _changeset} ->
        render(conn, "new.html", %{
          changeset: changeset
        })
    end
  end

  defp preload_associations(user) do
    Repo.preload(user, [:documents, :templates])
  end
end
