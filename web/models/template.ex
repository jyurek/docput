defmodule Docput.Template do
  use Docput.Web, :model

  schema "templates" do
    field :name
    field :body

    belongs_to :user, Docput.User
    has_many :documents, Docput.Document

    timestamps
  end

  def changeset(template, context, params \\ :empty)
  def changeset(template, :create, params) do
    template
    |> cast(params, ~w(name body user_id), [])
    |> assoc_constraint(:user)
  end
  def changeset(template, :update, params) do
    template
    |> cast(params, ~w(name body user_id), [])
    |> validate_length(:name, min: 1)
    |> validate_length(:body, min: 1)
    |> assoc_constraint(:user)
  end
end
