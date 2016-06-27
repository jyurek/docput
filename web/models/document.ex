defmodule Docput.Document do
  use Docput.Web, :model

  schema "documents" do
    field :name
    field :slug

    belongs_to :user, Docput.User

    timestamps
  end

  def changeset(document, context, params \\ %{})
  def changeset(document, :create, params) do
    document
    |> cast(params, ~w(name slug user_id _id), [])
    |> assoc_constraint(:user)
    |> assoc_constraint(:layout)
  end
  def changeset(document, :update, params) do
    document
    |> cast(params, ~w(name slug layout_id), [])
    |> assoc_constraint(:user)
    |> assoc_constraint(:layout)
  end
end
