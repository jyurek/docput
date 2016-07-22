defmodule Docput.RevisionController do
  use Docput.Web, :controller

  alias Docput.{Document, Revision}

  def show(conn, %{"slug" => slug, "version" => version}) do
    document = Repo.get_by!(Document, slug: slug)
    revision = Repo.get_by!(Revision, version: version, document_id: document.id)
    conn
    |> assign(:content, revision.body)
    |> render("show.html", layout: { Docput.LayoutView, "document.html" })
  end
end
