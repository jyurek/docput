defmodule Docput.RevisionsController do
  use Docput.Web, :controller

  alias Docput.{Document, Revision}
  alias Docput.Renderer

  def show(conn, %{"slug" => slug, "version" => version}) do
    document = Repo.get_by!(Document, slug: slug)
    revision = Repo.get_by!(Revision, version: version, document_id: document.id)
    conn
    |> assign(:content, revision.body)
    |> render("show.html", layout: { Docput.LayoutView, "document.html" })
  end

  defp preload_revision(document) do
    Repo.preload(document, [:revisions])
  end
end
