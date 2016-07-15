defmodule Docput.DocPutter do
  alias Docput.Document
  alias Docput.Revision
  alias Docput.Repo
  alias Docput.Renderer
  import Ecto.Changeset, only: [change: 2, apply_changes: 1]

  def create(params) do
    Repo.transaction fn ->
      document = find_or_new_from(params)
      {:ok, document} = document
        |> Document.changeset
        |> Repo.insert_or_update
      {:ok, _revision} = %Revision{}
        |> Revision.changeset(Map.put(params, "document_id", document.id))
        |> render_revision_to_body
        |> Repo.insert
    end
  end

  def find_or_new_from(params) do
    case find_by(params) do
      nil -> new_from(params)
      doc -> doc
    end
  end

  def find_by(params) do
    Repo.get_by(Document, slug: params["slug"])
  end

  def new_from(params) do
    %Document{
      name: params["name"],
      slug: params["slug"],
      user_id: params["user_id"]
    }
  end

  def render_revision_to_body(changeset) do
    changeset
    |> change(body: Renderer.to_html(changeset |> apply_changes))
  end
end
