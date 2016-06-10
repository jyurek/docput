defmodule Docput.Document do
  use Docput.Web, :model

  schema "documents" do
    field :name
    field :body

    belongs_to :template, Docput.Template
    belongs_to :user, Docput.User

    timestamps
  end

  def changeset(document, context, params \\ %{})
  def changeset(document, :create, params) do
    document
    |> cast(params, ~w(name body user_id template_id), [])
    |> assoc_constraint(:user)
    |> assoc_constraint(:template)
  end
  def changeset(document, :update, params) do
    document
    |> cast(params, ~w(name body template_id), [])
    |> assoc_constraint(:user)
    |> assoc_constraint(:template)
  end
end
