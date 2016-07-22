defmodule Docput.Layout do
  use Docput.Web, :model

  schema "layouts" do
    field :name
    field :body

    belongs_to :user, Docput.User
    has_many :documents, Docput.Document

    timestamps
  end

  def changeset(layout, params \\ %{}) do
    layout
    |> cast(params, ~w(name body user_id), [])
    |> validate_length(:name, min: 1)
    |> validate_length(:body, min: 1)
    |> assoc_constraint(:user)
  end
end
