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

  def create(conn, %{"document" => document_params}) do
    document_params = document_params
      |> Map.put("user_id", conn.assigns.current_user.id)
      |> Map.put("template_id", 1)

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
