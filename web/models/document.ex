defmodule Docput.Document do
  use Docput.Web, :model

  schema "documents" do
    field :name
    field :slug

    belongs_to :user, Docput.User
    has_many :revisions, Docput.Revision, on_delete: :delete_all

    timestamps
  end

  def changeset(document, params \\ %{})
  def changeset(document, params) do
    document
    |> cast(params, ~w(slug user_id), ~w(name))
  end
end
